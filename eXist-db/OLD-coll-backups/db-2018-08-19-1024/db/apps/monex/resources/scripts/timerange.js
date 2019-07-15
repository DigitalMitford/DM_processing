(function($) {
    $.TimerangeSetup = function () { 

        $.urlParam = function(name){
        	var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
        	if(results) {
        	    return results[1] || 0;    
        	}
        	
        }
        var selectedStartDate = $.urlParam('start');
        if(selectedStartDate) { 
            selectedStartDate = moment(selectedStartDate);
        }else {
            selectedStartDate = moment().subtract(1, 'days');
        }
        
        var selectedEndDate = $.urlParam('end');
        if(selectedEndDate) { 
            selectedEndDate = moment(selectedEndDate);
        }else {
            selectedEndDate = moment();
        }
        

        // console.log("start: ",selectedStartDate);
        // console.log("end: ",selectedEndDate);
        
        $('#reportrange span').html(selectedStartDate.format('MMMM D, YYYY') + ' - ' + selectedEndDate.format('MMMM D, YYYY'));
        $('#reportrange').daterangepicker({
                    format: 'MM/DD/YYYY',
                    startDate: selectedStartDate,
                    endDate: selectedEndDate,
                    dateLimit: { days: 60 },
                    showDropdowns: true,
                    showWeekNumbers: true,
                    timePicker: false,
                    timePickerIncrement: 1,
                    timePicker12Hour: true,
                    ranges: {
                       'Today': [moment(), moment()],
                       'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                       'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                       'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                       'This Month': [moment().startOf('month'), moment().endOf('month')],
                       'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                    },
                    opens: 'left',
                    drops: 'down',
                    buttonClasses: ['btn', 'btn-sm'],
                    applyClass: 'btn-primary',
                    cancelClass: 'btn-default',
                    separator: ' to ',
                    locale: {
                        applyLabel: 'Submit',
                        cancelLabel: 'Cancel',
                        fromLabel: 'From',
                        toLabel: 'To',
                        customRangeLabel: 'Custom',
                        daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr','Sa'],
                        monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
                        firstDay: 1
                    }
                }, function(start, end, label) {
                    // console.log(start.toISOString(), end.toISOString(), label);
                    $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
                    var startNew = new Date(start).getTime();
                    var endNew =new Date(end).getTime();
                    // console.log("startNew:", startNew, " endNew: ", endNew);
                    var url = $(location).attr('protocol') + "//" + $(location).attr('hostname') + ":" + $(location).attr('port') + $(location).attr('pathname'); 
                    // console.log("url: ", url);
                    var search = $(location).attr('search');
                    // console.log("search: ", search);
                    
                    
                    var queryString = {};
                    search.replace(
                        new RegExp("([^?=&amp;]+)(=([^&amp;]*))?", "g"),
                        function($0, $1, $2, $3) { queryString[$1] = $3; }
                    );
                    var url = url + "?instance=" + JMX_INSTANCE  + "&start=" + start.toISOString() + "&end=" + end.toISOString();
                    // console.log("url new: ", url)
                    location.href = url;
                }
        ); // end $('#reportrange').daterangepicker()              
    };
    
})(jQuery);
