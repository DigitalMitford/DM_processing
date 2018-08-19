
function findByName(nodes, name) {
    if (nodes instanceof Array) {
        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].name() == name) {
                return nodes[i];
            }
        }
    }
    return null;
}

function addKillBtn(node, data) {
    $(node).find(".kill-query").click(function(ev) {
        ev.preventDefault();
        if (JMX_INSTANCE.version === 0) {
            $.ajax({
                url: "modules/admin.xql",
                data: { action: "kill", id: data.id() },
                type: "POST"
            });
        } else {
            JMX.connection.invoke("killQuery", "org.exist.management.exist:type=ProcessReport", [data.id()]);
        }
    });
}

function uptime(data) {
    var uptime = parseInt(data);
    var cd = 24 * 60 * 60 * 1000,
        ch = 60 * 60 * 1000,
        d = Math.floor(uptime / cd),
        h = '0' + Math.floor( (uptime - d * cd) / ch),
        m = '0' + Math.round( (uptime - d * cd - h * ch) / 60000);
    if (d > 0) {
        status = d + "d " + h.substr(-2) + "h";
    } else {
        status = h.substr(-2) + "h " + m.substr(-2) + "m";
    }
    return status;
}

JMX.TimeSeries = (function() {
    var options = {
        series: {
            lines: {
                show: true,
                lineWidth: 1.2,
                fill: true
            }
        },
        xaxis: {
            mode: "time",
            show: true,
            tickSize: [2, "second"],
            tickFormatter: function (v, axis) {
                var date = new Date(v);

                if (date.getSeconds() % 20 == 0) {
                    var hours = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
                    var minutes = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
                    var seconds = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();

                    return hours + ":" + minutes + ":" + seconds;
                } else {
                    return "";
                }
            },
            axisLabel: "Time",
            axisLabelUseCanvas: false,
            axisLabelFontSizePixels: 12,
            axisLabelFontFamily: 'Verdana, Arial',
            axisLabelPadding: 10
        },
        yaxis: {
            min: 0,
            max: 100,
            axisLabelUseCanvas: true,
            axisLabelFontSizePixels: 12,
            axisLabelFontFamily: 'Verdana, Arial',
            axisLabelPadding: 6
        },
        legend: {
            show: true,
            labelBoxBorderColor: "#fff"
        }
    };

    function getProperty(data, property) {
        if (!data) {
            return 0;
        }
        var components = property.split(".");
        var prop = data;
        for (var i = 0; i < components.length; i++) {
            if (prop.hasOwnProperty(components[i])) {
                prop = prop[components[i]];
            } else {
                break;
            }
        }
        return prop || 0;
    };

    Constr = function(container, labels, properties, propertyMaxY, unitY) {
        this.container = $(container);
        this.properties = properties;
        this.propertyMaxY = propertyMaxY;
        this.unitY = unitY;
        this.dataset = [];
        for (var i = 0; i < labels.length; i++) {
            this.dataset.push({
                label: labels[i],
                data: []
            });
        }
    };

    Constr.prototype.update = function(data) {
        var max = parseInt(getProperty(data, this.propertyMaxY));
        if (this.unitY == "mb") {
            max = max / 1024 / 1024;
        }
        options.yaxis.max = max;
        if (this.dataset[0].data.length > 100) {
            for (var i = 0; i < this.dataset.length; i++) {
                this.dataset[i].data.shift();
            }
        }
        var now = new Date().getTime();
        for (var i = 0; i < this.properties.length; i++) {
            var val = getProperty(data, this.properties[i]);
            if (this.unitY == "mb") {
                val = parseInt(val) / 1024 / 1024;
            }
            this.dataset[i].data.push([now, parseInt(val)]);
        }

        $.plot(this.container, this.dataset, options);
    };

    return Constr;
}());

JMX.connection = (function() {
    "use strict";

    var JMX_NS = "http://exist-db.org/jmx";

    var version = 0;

    var viewModel = null;

    var instanceMap = {};

    var currentInstance;

    var onUpdateCb;
    var poll = true;
    var pollPeriod = 1000;
    
    function Instance(config, schedulerActive) {
        this.name = ko.observable(config.name);
        this.url = ko.observable(config.url);
        this.baseURL = config.url;
        this.token = config.token;
        var status = schedulerActive ? config.status : "Stopped";
        if (status == "Checking" || status == "PING_OK" || status == "Stopped") {
            this.status = ko.observable(status);
            this.message = ko.observable("");
        } else {
            this.message = ko.observable(status);
            this.status = ko.observable("PING_ERROR");
        }
        this.elapsed = ko.observable("00:00.000");
        this.time = ko.observable("0");

        this.icon = ko.computed(function() {
            switch (this.status()) {
                case "Checking":
                    return "fa fa-refresh primary";
                case "PING_OK":
                    return "fa fa-check-circle-o success";
                default:
                    return "fa fa-warning danger";
            }
        }, this);
    }

    function Instances(instances, schedulerActive) {
        this.instances = ko.observableArray(instances);
        this.status = ko.observable(schedulerActive ? "Checking" : "Stopped");

        this.warnings = ko.computed(function() {
            var fails = 0;
            for (var i = 0; i < this.instances().length; i++) {
                var status = this.instances()[i].status();
                if (status == "PING_ERROR" ||
                    status == "Connection Error") {
                    fails++;
                }
            }
            return fails === 0 ? "" : fails;
        }, this);

        this.schedule = function() {
            var self = this;
            var newStatus = self.status() == "Stopped" ? "Checking" : "Stopped";
            self.status(newStatus);
            $.ajax({
                url: "modules/" + (newStatus == "Stopped" ? "unschedule.xql" : "schedule.xql"),
                method: "GET",
                success: function() {
                    for (var i = 0; i < self.instances().length; i++) {
                        self.instances()[i].status(newStatus);
                    }
                }
            });
        };
    }

    function connect(channel, callback) {
        if (!Modernizr.websockets) {
            $("#browser-alert").show(400);
            setTimeout(function() { $("#browser-alert").hide(200); }, 8000);
            return;
        }

        var rootcontext = location.pathname.slice(0, location.pathname.indexOf("/apps"));
        var proto = window.location.protocol == "https:" ? "wss" : "ws";
        var url = proto + "://" + location.host + rootcontext + "/rconsole";
        var connection = new WebSocket(url);

        // Log errors
        connection.onerror = function (error) {
            $("#status").text("Connection error ...");
            console.log('WebSocket Error: %o', error);
        };

        connection.onclose = function() {
            $("#status").text("Disconnected.");
        };

        connection.onopen = function() {
            $("#status").text("Connected.");
            connection.send('{ "channel": "' + channel + '" }');
        };

        // Log messages from the server
        connection.onmessage = function (e) {
            if (e.data == "ping") {
                return;
            }

            var data = JSON.parse(e.data);
            console.log("ping received for %s: %s", data.instance, data.status);

            callback(data);
        };
    }

    return {
        invoke: function(operation, mbean, args) {
            var url;
            if (currentInstance.name() == "localhost") {
                url = location.pathname.replace(/^(.*)\/apps\/.*$/, "$1") +
                    "/status?operation=" + operation + "&mbean=" + mbean + "&token=" + currentInstance.token;
            } else {
                url = "modules/remote.xql?operation=" + operation + "&mbean=" + mbean + "&name=" + currentInstance.name();
            }
            if (args) {
                for (var i = 0; i < args.length; i++) {
                    url += "&args=" + args[i];
                }
            }
            $.ajax({
                url: url,
                type: "GET",
                timeout: 10000,
                error: function(xhr, status, error) {
                    $("#connection-alert").show(400).find(".message")
                        .text("Operation '" + operation + "' failed or is not supported on this server instance.");
                    setTimeout(function() { $("#connection-alert").hide(200); }, 3000);
                }
            });
        },

        poll: function(onUpdate) {
            onUpdateCb = onUpdate;
            if (!poll) {
                return;
            }
            var url;
            var name = currentInstance.name();
            if (name == "localhost") {
                url = location.pathname.replace(/^(.*)\/apps\/.*$/, "$1") +
                    "/status?c=instances&c=processes&c=locking&c=memory&c=caches&c=system&c=operatingsystem&token=" + currentInstance.token;
            } else {
                url = "modules/remote.xql?name=" + name;
            }

            $.ajax({
                url: url,
                type: "GET",
                timeout: 10000,
                success: function(xml) {
                    $("#connection-alert").hide(400);
                    var data = JMX.util.fixjs(JMX.util.jmx2js(xml));
                    if (data) {
                        if (!data.jmx.version) {
                            data.jmx.version = 0;
                        }
                        currentInstance.version = data.jmx.version;
                        // console.dir(data);
                        var rootDom = document.getElementById("dashboard");
                        if (rootDom) {
                            if (!viewModel) {
                                viewModel = ko.mapping.fromJS(data);
                                viewModel.gc = function() {
                                    JMX.connection.invoke("gc", "java.lang:type=Memory");
                                };
                                if (data.jmx.ProcessReport.TrackRequestURI) {
                                    $("#threshold").val(data.jmx.ProcessReport.MinTime);
                                    $("#track-uri").prop("checked", data.jmx.ProcessReport.TrackRequestURI == "true");
                                    $("#history-timespan").val(data.jmx.ProcessReport.HistoryTimespan);
                                } else {
                                    $("#configure-history").hide();
                                }
                                if (name == "localhost") {
                                    viewModel.url = "";
                                } else {
                                    viewModel.url = currentInstance.url().replace(/\/exist\/?$/, "");
                                }
                                ko.applyBindings(viewModel, rootDom);
                            } else {
                                ko.mapping.fromJS(data, viewModel);
                            }
                        }
                        if (onUpdate) {
                            onUpdate(data);
                        }
                        setTimeout(function() { JMX.connection.poll(onUpdate); }, pollPeriod);
                    } else {
                        $("#connection-alert").show(400).find(".message").text("No response from server. Retrying ...");
                        setTimeout(function() { JMX.connection.poll(onUpdate); }, 5000);
                    }
                },
                error: function(xhr, status, error) {
                    $("#connection-alert").show(400).find(".message")
                        .text("Connection to server failed. Retrying ...");
                    setTimeout(JMX.connection.poll, 5000);
                }
            });
        },

        init: function(config, schedulerActive) {
            instanceMap = {};
            var instances = [];
            for (var i = 0; i < config.length; i++) {
                var instance = new Instance(config[i], schedulerActive);
                instanceMap[config[i].name] = instance;
                if (config[i].name == JMX_INSTANCE) {
                    currentInstance = instance;
                }
                if (config[i].url != "local") {
                    instances.push(instance);
                }
            }
            var viewModel = new Instances(instances, schedulerActive);
            var domRoot = document.getElementById("remotes");
            if (domRoot) {
                ko.applyBindings(viewModel, domRoot);
            }
            ko.applyBindings(viewModel, $("#notifications")[0]);

            connect("jmx.ping", JMX.connection.ping);
        },

        ping: function(data) {
            var instance = instanceMap[data.instance];
            if (!instance) {
                console.log("instance not found: %s", data.instance);
                return;
            }
            instance.elapsed(data.elapsed);
            switch (data.status) {
                case "ok":
                    instance.status(data.SanityReport.Status);
                    instance.time(data.SanityReport.PingTime);
                    instance.message("");
                    break;
                case "pending":
                    instance.status("Checking");
                    instance.time("?");
                    instance.message("");
                    break;
                default:
                    instance.status("PING_ERROR");
                    instance.message(data.status);
                    instance.time("?");
            }
        },
        
        setPollPeriod: function(period) {
            pollPeriod = parseFloat(period) * 1000;
        },
        
        togglePolling: function() {
            if (poll) {
                poll = false;
            } else {
                poll = true;
                JMX.connection.poll(onUpdateCb);
            }
        }
    };
}());

$(function() {
    JMX.connection.init(JMX_INSTANCES, JMX_ACTIVE);

    $("#configure").click(function(ev) {
        ev.preventDefault();
        var threshold = $("#threshold").val();
        var historyTimespan = $("#history-timespan").val();
        var trackURI = $("#track-uri").is(":checked");
        JMX.connection.invoke("configure", "org.exist.management.exist:type=ProcessReport", [threshold, historyTimespan, trackURI]);
    });
    // the following block should only be run on the main dashboard page
    $("#dashboard").each(function() {
        var charts = [];
        $(".chart").each(function() {
            var node = $(this);
            var labels = node.attr("data-labels");
            var properties = node.attr("data-properties");
            var unitY = node.attr("data-unit-y") || "";
            var max = node.attr("data-max-y");

            charts.push(new JMX.TimeSeries(node, labels.split(","), properties.split(","), max, unitY));
        });
        $("#poll-period").ionRangeSlider({
            min: 0.5,
            max: 60.0,
            from: 1.0,
            type: "single",
            step: 0.1,
            postfix: " sec",
            hasGrid: true,
            onChange: function(data) {
                JMX.connection.setPollPeriod(data.from);
            }
        });
        $("#pause-btn").click(function(ev) {
            JMX.connection.togglePolling();
        });
        JMX.connection.poll(function(data) {
            for (var i = 0; i < charts.length; i++) {
                charts[i].update(data);
            }
            $(".stack").popover({
                placement: "auto right",
                html: true,
                container: "#dashboard",
                trigger: "focus",
                template: '<div class="popover stacktrace" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><pre class="popover-content"></pre></div>'
            });
        });
    });

    // for (var server in JMX_INSTANCES) {
    //     JMX.connection.ping(JMX_INSTANCES[server]);
    // }
});
