import Rails from "@rails/ujs"
//
//Add the Rails global variable.  Again, something ignored in examples and documentation and left
//for developers to just 'figure it out'.
//
window.Rails = Rails;

import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
require.context('../images', true)  //tells webpack path to images


import "core-js/stable";
import "regenerator-runtime/runtime";
//
//Tried Using global.* instead of window.* to define exported variables. Didn't help.
//See this posting for details:
//https://makandracards.com/makandra/70313-webpacker-side-effects-of-using-window-within-the-provideplugin
//
import JQuery from 'jquery';
window.$ =  JQuery;
window.jQuery = JQuery;


//None of this commented out stuff worked properly
//global.jQuery = JQuery;
//import '@popperjs/core';
//import { createPopper } from '@popperjs/core';
//import * as Bootstrap from 'bootstrap/dist/js/bootstrap.esm.min.js'; 
//import * as Bootstrap from 'bootstrap'; 
//import Modal from "expose-loader?exposes=Modal,modal!bootstrap"
//import { Modal } from 'bootstrap'; 
//window.modal = Modal;

//
//require uses CommonJS protocols. Despite all the documentation about using ES6 (import), require is 
//the one that works in a js.erb file.
//
window.bootstrap = require('bootstrap/dist/js/bootstrap.bundle.js');


import Highcharts from 'highcharts';
// Load the modules
import addExporting from 'highcharts/modules/exporting';
import addMore from "highcharts/highcharts-more";
import addDumbbell from "highcharts/modules/dumbbell";
import addLollipop from "highcharts/modules/lollipop";
import addBrokenAxis from "highcharts/modules/broken-axis";
// Alternatively, this is how to load Highstock. Highmaps and Highcharts Gantt are similar.
//import Highcharts from 'highcharts/highstock';

// Initialize exporting module. (CommonJS only)
addExporting(Highcharts);
addMore(Highcharts);
addDumbbell(Highcharts);
addLollipop(Highcharts);
addBrokenAxis(Highcharts);
window.Highcharts = Highcharts;

import "social-share-button"
import datetimepicker from "jquery-datetimepicker"
import "mylife"
