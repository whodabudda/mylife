import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
require.context('../images', true)  //tells webpack path to images
//window.jQuery = jQuery;
import "core-js/stable";
import "regenerator-runtime/runtime";
import JQuery from 'jquery';
window.$ = window.JQuery = JQuery;

//import Ujs from "@rails/ujs";
//Ujs.start()
//require('expose-loader?Highcharts!highcharts');
//import Highcharts from "highcharts/highcharts";
//require('highcharts/highcharts-more');
//window.Highcharts = Highcharts;
// Alternatively, this is how to load Highstock. Highmaps and Highcharts Gantt are similar.
//import Highcharts from 'highcharts/highstock';
import Highcharts from 'highcharts';

// Load the modules
import addExporting from 'highcharts/modules/exporting';
import addMore from "highcharts/highcharts-more";
import addDumbbell from "highcharts/modules/dumbbell";
import addLollipop from "highcharts/modules/lollipop";
import addBrokenAxis from "highcharts/modules/broken-axis";

// Initialize exporting module. (CommonJS only)
addExporting(Highcharts);
addMore(Highcharts);
addDumbbell(Highcharts);
addLollipop(Highcharts);
addBrokenAxis(Highcharts);
window.Highcharts = Highcharts;




import "tether"
import "bootstrap" 
import "stylesheets"
import "social-share-button"
import "jquery-datetimepicker"

