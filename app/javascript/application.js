// Entry point for the build script in your package.json
// app/javascript/application.js
console.log("Hello from application.js!")
// jQuery - must be first and exposed globally
import jQuery from 'jquery'
window.$ = window.jQuery = jQuery

import Rails from "@rails/ujs"
Rails.start()

// Turbo (replaces Turbolinks)
import "@hotwired/turbo-rails"

// ActiveStorage (if you use file uploads)
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

// Bootstrap - expose globally for js.erb files
import * as bootstrap from 'bootstrap/dist/js/bootstrap.bundle.js'
window.bootstrap = bootstrap

// Highcharts
// Highcharts v12 - modules self-register on import
console.log("Highcharts version:", Highcharts.version)
import Highcharts from 'highcharts'
import 'highcharts/modules/exporting'
console.log("Highcharts exporting module loaded.")
import 'highcharts/highcharts-more'
console.log("Highcharts more module loaded.")
import 'highcharts/modules/dumbbell'
console.log("Highcharts dumbbell module loaded.")
import 'highcharts/modules/lollipop'
console.log("Highcharts lollipop module loaded.")
import 'highcharts/modules/broken-axis'
console.log("Highcharts broken-axis module loaded.")    

window.Highcharts = Highcharts
console.log("Highcharts modules loaded.")

// Datetimepicker (requires jQuery to be loaded first)
//import 'jquery-datetimepicker'

// Social share button (if still using)
import "social-share-button"

// ActionCable channels
import "./channels"

// Your app code
import "./mylife"
console.log("MyLife app code loaded.")