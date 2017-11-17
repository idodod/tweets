function update_read_state(tweet_id) {
    $.ajax({
        url: '/tweets/'+tweet_id,
        type: 'PATCH',
        dataType: 'json',
        data: {"tweet": { "tweet_id": tweet_id}},
        complete: function (jqXHR, textStatus) {
            // callback
        },
        success: function (data, textStatus, jqXHR) {
            // inform user that it was a sucess like:
            var myId = '#' + "tr_" + tweet_id.toString();
            $(myId)[0].style.display = "none"
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert("There was a problem marking tweet as read");
        }
    });
}
