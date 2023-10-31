function buttons() {
    var openAllBtn = $('#set-all-future-btn');
    var closeAllBtn = $('#set-all-closed-btn');
    var nextBtn = $('#next-active-btn');
    var prevBtn = $('#prev-active-btn');

    //Kan vara värt att göra en separat sida för dessa PUT
    openAllBtn.click(function () {
        if (confirm("Är du säker på att göra alla punkter framtida? Detta går inte att ångra.") ) {
            $.ajax({
                url: '/admin/aktuell-dagordning/open_all', 
                method: 'PUT'
            });
        }
    });
    
    closeAllBtn.click(function () {
        if (confirm("Är du säker på att göra alla punkter stängda? Detta går inte att ångra.") ) {
            $.ajax({
                url: '/admin/aktuell-dagordning/close_all',
                method: 'PUT'
            });
        }
    });

    nextBtn.click(function () {
        console.log("next")
        $.ajax({
            url: '/admin/aktuell-dagordning/next_active',
            method: 'PUT'
        });
    });
    prevBtn.click(function () {
        $.ajax({
            url: '/admin/aktuell-dagordning/prev_active',
            method: 'PUT'
        });
    });

}


$(document).on('turbolinks:load', buttons)