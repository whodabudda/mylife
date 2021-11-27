
    $('.tr_clone_add_btn').bind('ajax:beforeSend', function(event, xhr, settings){
      console.log("ajax:beforeSend event: " + event);
      console.log("ajax:beforeSend xhr: " + xhr);
      console.log("ajax:beforeSend settings: " + settings);
    });
  
    $('.tr_clone_add_btn').bind('ajax:success', function(evt, data, status, xhr){
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
    $.datetimepicker.setLocale('en'); 
    $('.default_datetimepicker').datetimepicker({
          format: 'Y-m-d H:i:s O',
          lazyInit:true,
          step: 1,
          validateOnBlur:false

    });

*/