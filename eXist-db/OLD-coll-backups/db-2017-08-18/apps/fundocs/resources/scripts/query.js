
function search() {
    var data = $("#fun-query-form").serialize();
    $.ajax({
	    type: "POST",
	    url: "ajax.html",
	    data: data + "&action=search",
	    success: function (data) {
            $("#results").fadeOut(100, function() {
                $(this).html(data);
                $(this).fadeIn(100, function() {
                    $(".signature").highlight({theme: "clouds"});
                });
                timeout = null;
            });
	    }
    });
}

function checkLogin() {
    $.ajax({
        url: "login",
        dataType: "json",
        success: function(data) {
            reindex();
        },
        error: function (xhr, textStatus) {
            $("#loginDialog").modal("show");
        }
    });
}

function reindex() {
    $("#messages").empty();
    $("#f-load-indicator").show();
    $.ajax({
        type: "POST",
        dataType: "json",
        url: "modules/reindex.xql",
        success: function (data) {
            $("#f-load-indicator").hide();
            if (data.status == "failed") {
                $("#messages").text(data.message);
            } else {
                window.location.href = ".";
            }
        }
    });
}

var timeout = null;

$(document).ready(function() {
    var loginDialog = $("#loginDialog");
    loginDialog.modal({
        show: false
    });
    $("form", loginDialog).submit(function(ev) {
        var params = $(this).serialize();
        $.ajax({
            url: "login",
            data: params,
            dataType: "json",
            success: function(data) {
                loginDialog.modal("hide");
                reindex();
            },
            error: function(xhr, textStatus) {
                $(".login-message", loginDialog).show().text("Login failed!");
            }
        });
        return false;
    });
    $("#f-load-indicator").hide();
    $("#query-field").keyup(function() {
        var val = $(this).val();
        if (val.length > 3) {
            if (timeout)
                clearTimeout(timeout);
            timeout = setTimeout(search, 300);
        }
    });
    
    $("#f-btn-reindex").click(function(ev) {
        ev.preventDefault();
        checkLogin();
    });
    
    $(".signature").highlight({theme: "clouds"});
    
    $("#fun-query-form *[data-toggle='tooltip']").tooltip();
});