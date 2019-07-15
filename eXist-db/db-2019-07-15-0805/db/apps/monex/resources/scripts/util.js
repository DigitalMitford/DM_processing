var JMX = {};

JMX.util = (function() {

    return {
        jmx2js: function (node) {
            if (!node) {
                return null;
            }
            if (!(node.firstChild || node.attributes.length > 0)) {
                return null;
            }
            var parent = {};
            if (node.nodeType == Node.ELEMENT_NODE) {
                for (var i = 0; i < node.attributes.length; i++) {
                    parent[node.attributes[i].localName] = node.attributes[i].nodeValue;
                }
            }
            var child = node.firstChild;
            while (child) {
                if (child.nodeType == Node.ELEMENT_NODE) {
                    if (child.localName == "row") {
                        if (!(parent instanceof Array)) {
                            parent = [];
                        }
                        parent.push(JMX.util.jmx2js(child));
                    } else {
                        var existing = parent[child.localName];
                        if (existing) {
                            if (!(existing instanceof Array)) {
                                parent[child.localName] = [ existing ];
                                existing = parent[child.localName];
                            }
                            existing.push(JMX.util.jmx2js(child));
                        } else {
                            parent[child.localName] = JMX.util.jmx2js(child);
                        }
                    }
                } else if (node.childNodes.length == 1) {
                    return child.nodeValue;
                }
                child = child.nextSibling;
            }
            return parent;
        },

        fixjs: function(data) {
            if (!data) {
                return null;
            }
            if (data.jmx.ProcessReport) {
                var queries = data.jmx.ProcessReport.RunningQueries;
                if (!queries || !queries.length) {
                    data.jmx.ProcessReport.RunningQueries = [];
                }
                var jobs = data.jmx.ProcessReport.RunningJobs;
                if (!jobs || !jobs.length) {
                    data.jmx.ProcessReport.RunningJobs = [];
                }
                var recent = data.jmx.ProcessReport.RecentQueryHistory;
                if (!recent || !recent.length) {
                    data.jmx.ProcessReport.RecentQueryHistory = [];
                }
            }
            if (data.jmx.LockManager) {
                var waiting = data.jmx.LockManager.WaitingThreads;
                if (!waiting || !waiting.length) {
                    data.jmx.LockManager.WaitingThreads = [];
                }
            }
            if (data.jmx.Database) {
                var active = data.jmx.Database.ActiveBrokersMap;
                if (!active || !active.length) {
                    data.jmx.Database.ActiveBrokersMap = [];
                }
            }
            return data;
        }
    }
}());