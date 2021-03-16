'use strict';

require("./styles.scss");

const {Elm} = require('./Main');
var app = Elm.Main.init({flags: 6});

app.ports.toJs.subscribe(data => {
    console.log(data);
})