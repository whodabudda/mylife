    /*
      Need to wait for document and turbolinks to load before running code to build
      the chart.  
      https://stackoverflow.com/questions/63948287/bootstrap-5-navbar-align-items-right
      window.addEventListener('turbolinks:load', function () {
       //document.getElementById("show-chart").click();
       console.log("reviews show-chart has been clicked")
      })
      */
     /*
      This block is needed as workaround to turbolinks not always firing its
      load event.  Without this, the eventlistener added above will not work
      consistently, for example when navigating to 'home'
      https://github.com/turbolinks/turbolinks/issues/62 
      if (document.readyState === "interactive") {
        const event = document.createEvent("Event");
        event.initEvent("turbolinks:load", true, true);
        document.dispatchEvent(event);
      }
      function handleReviewChangeDisable() {
        // Serialize form data
        var formData = $('#review-form').serialize();

        // Set href attribute for the hidden link
        var newHref = '<%= show_regression_path %>' + '?' + formData;
        $('#show-chart').attr('href', newHref);

        // Trigger a click on the hidden link
        document.getElementById('show-chart').click();
        console.log("reviews handleReviewChangeDisable has executed")
      }
      */