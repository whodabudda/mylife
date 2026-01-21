//
// Settings for https://xdsoft.net/jqplugins/datetimepicker/
//
    $.datetimepicker.setLocale('en'); 
    $('.default_datetimepicker').datetimepicker({
          format: 'Y-m-d H:i:s O',
//          format: 'Y-m-d H O',
          lazyInit:true,
          step: 1,
          validateOnBlur:false

    });
//
// datetimepicker seems to prevent UJS from recognizing the data-remote setting, so the ajax call
// is not invoked through remote:true.  It is invoked if you tab out of the field, but not if you 
// close the window by clicking on the frame. Therefore, we have to check for when the input field
// no longer has focus (blur event) and call the UJS function explicitly if data has been changed.
//
let myinputObject = document.querySelector('.mydatetimeInput');
//
//some docs say there is a rails.change event.  I couldn't find one in Rails 6.
//
//document.addEventListener('rails.change',(event) => {
//  console.log("got event for rails.change")
//});
myinputObject.addEventListener('blur', (event) => {
  console.log("got element for occur_dttm_input old:" + event.target.defaultValue + " new: " + event.target.value)
  //from stackexchange:   
  //https://stackoverflow.com/questions/12683524/with-rails-ujs-how-to-submit-a-remote-form-from-a-function
  if(event.target.value!=event.target.defaultValue) {
   Rails.handleRemote.call(event.target, event);
   event.target.defaultValue = event.target.value;
  }
});