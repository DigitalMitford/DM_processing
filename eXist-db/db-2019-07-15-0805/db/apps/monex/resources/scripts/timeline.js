(function($) {
    $.TimelineOptions = function (element) { 
        // console.log("timeline options");
        var options = {
                series: {
                    lines: {
                        lineWidth: 1.2,
                        fill: true
                    },
                    points: {
                        show: false
                    }
                },
                xaxis: {
                    mode: "time",
                    show: true,
                    // minTickSize: [1, "minute"],
                    timeformat: "%Y/%m/%d<br/>%H:%M:%S",
                    ticks: 10,
                    axisLabel: "Time",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'sans-serif',
                    axisLabelPadding: 10,
                },
                yaxis: {
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'sans-serif',
                    axisLabelPadding: 6,
                    autoscaleMargin: 0.1
                },
                legend: {
                    show: true,
                    labelBoxBorderColor: "#fff"
                },
                grid: {
                    hoverable: true,
                    clickable: true,
                    autoHighlight: true
                },
                selection: {
                    mode: "x"
                },
                tooltip: false
            }
            return options
    };
    
    $.TimelineSetup = function (container, dataset,options) { 
        // console.log("TimelineSetup.conatiner: ", container);
        // console.log("TimelineSetup.dataset: ", dataset);
        
        // console.log("TimelineSetup.options: ", options);
        
        var plot = $.plot(container, dataset, options);
        // console.log("timeline: ",plot);
        $.TimelineFunctions(plot, container, dataset, options); 
    };
    
    $.TimelineFunctions = function (plot, container, data, options) { 
        var axis = plot.getAxes().xaxis;
        var min = axis.options.min;
        var max = axis.options.max;
        $(document).on("chart:zoomIn", function(event, min, max) {
            var axis = plot.getAxes().xaxis;
            var opts = axis.options;
            opts.min = min;
            opts.max = max;
            plot.setupGrid();
            plot.draw();
        });
        container.bind("plothover", function (event, pos, item) {
             var str = "(" + pos.x.toFixed(2) + ", " + pos.y.toFixed(2) + ")";
             // console.log("str: ", str);
    
            if (item) {
    
                var x = item.datapoint[0].toFixed(2),
                    y = item.datapoint[1].toFixed(2);
                var date = new Date(x-0)
                 // console.log("item: x:", x, " date:",date, " y:",y);
    
                $("#tooltip").html(item.series.label + " at " + date + " = " + y).css({top: item.pageY+5, left: item.pageX+5, display:"block"});
            } else {
                $("#tooltip").hide();
            }
        });
    
        container.bind("plotselected", function (event, ranges) {
            $(document).trigger("chart:zoomIn", [ranges.xaxis.from, ranges.xaxis.to]);
            plot.clearSelection();
        });
        container.parent().parent().find(".zoom-out").click(function(ev) {
            ev.preventDefault();
            $(document).trigger("chart:zoomIn", [min, max]);
        });
        container.bind("plotclick", function (event, pos, item) {
            // axis coordinates for other axes, if present, are in pos.x2, pos.x3, ...
            // if you need global screen coordinates, they are pos.pageX, pos.pageY
            if (item) {
                var millis = new Date(item.datapoint[0]);
                // console.log(millis.toISOString());
                window.open("details.html?timestamp=" + item.datapoint[0] + "&instance=" + JMX_INSTANCE, "_blank");
            }
        });    
        
    }
    
    var methods = {

        init: function() {
            var options = $.TimelineOptions();
            this.each(function() {
                var container = $(this);
                var data = container.data("data");
                var plot = $.plot(container, data, options);
                $.TimelineFunctions(plot, container, data, options);
            });
        }
    };

    $.fn.timeline = function (method) {
        //http://www.flotcharts.org
        if (methods[method]) {
            return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof method === 'object' || !method) {
            return methods.init.apply(this, arguments);
        } else {
            alert('Method "' + method + '" not found!');
        }
    };
})(jQuery);
