$(function() { 
    var xml = $.parseXML($("#jmx-data").text());
    var data = JMX.util.fixjs(JMX.util.jmx2js(xml)); 
    var viewModel = ko.mapping.fromJS(data);
    ko.applyBindings(viewModel, document.getElementById("details"));
    $("#recentQueries").DataTable( { responsive: true } );

    $(".thread").hover(function(ev) {
        var name = $(this).text();
        $(".thread").each(function() {
            if ($(this).text() == name) {
                $(this).addClass("bg-yellow");
            } else {
                $(this).removeClass("bg-yellow");
            }
        });
    });
    
    $(".stack").popover({
        placement: "auto right",
        html: true,
        container: "#details",
        trigger: "click",
        template: '<div class="popover stacktrace" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><pre class="popover-content"></pre></div>'
    });
}); 
