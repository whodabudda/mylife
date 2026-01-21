
    $('.tr_clone_add_btn').on('ajax:beforeSend', function(event, xhr, settings){
      console.log("ajax:beforeSend event: " + event);
      console.log("ajax:beforeSend xhr: " + xhr);
      console.log("ajax:beforeSend settings: " + settings);
    });
  
    $('.tr_clone_add_btn').on('ajax:success', function(evt, data, status, xhr){
      var $tr = $(this).closest('.tr_clone');
      console.log("ajax:success data: " + data);
      console.log("ajax:success table row: " + $tr);
    });
    $(document).on("ajax:success", '.tr_clone_remove_btn', function(evt, data, status, xhr){
      console.log("ajax:success evt: " + JSON.stringify(evt));
      console.log("ajax:success data: " + JSON.stringify(data));
      console.log("ajax:success status: " + JSON.stringify(status));
      console.log("ajax:success xhr: " + JSON.stringify(xhr));
      $(this).closest('tr').fadeOut().remove();
    });

     /*
      Need to wait for document and turbolinks to load before running code to build
      the chart. 
      https://stackoverflow.com/questions/63948287/bootstrap-5-navbar-align-items-right

      Place actions here that are needed for the initial load of a page.
      Other actioons after the page is loaded will have their own listeners.  
      */
      console.log("user_session_home.js has been loaded")
      window.addEventListener('turbo:load', function () {
       // Use the global variable 'initialPage' to set the current page. Each page
       //that wants to do something needs to set this variable.
       if (initialPage === "user_session_home") {
        // Perform actions specific to the user_session_home page
          console.log("user_session_home initialPage has been loaded")
          document.getElementById("show-chart").click();
          console.log("user_session show-chart id has been clicked")
          //document.getElementById("salt-row-for-new-user").click();
          //console.log("user_session salt-row-for-new-user has been clicked")
       } else if (initialPage === "review_home") {
        // Perform actions specific to the review_home page
          console.log("review_home initialPage has been loaded")
          document.getElementById("show-chart").click();
          console.log("review_home show-chart id has been clicked")
       } else {
          console.log("check on initialPage has fallen through")
       }
       //unset the variable so it is not inadvertently fired on other pages.
       initialPage = "" 
      })

     /*
      This block is needed as workaround to turbolinks not always firing its
      load event.  Without this, the eventlistener added above will not work
      consistently, for example when navigating to 'home'
      https://github.com/turbolinks/turbolinks/issues/62 
      if (document.readyState === "interactive") {
        const event = document.createEvent("Event");
        event.initEvent("turbo:load", true, true);
        document.dispatchEvent(event);
      }
      */

// Convenience function to show Bootstrap modals
window.showModal = function(id) {
  new bootstrap.Modal(document.getElementById(id)).show()
}

/*
    $.datetimepicker.setLocale('en'); 
    $('.default_datetimepicker').datetimepicker({
          format: 'Y-m-d H:i:s O',
          lazyInit:true,
          step: 1,
          validateOnBlur:false

    });

*/