"use strict";

var Rd = ReactDatum;
var Tilegrid = ReactTilegrid;

// This is the source for the left-right iframe viewer used to
// view examples on our github.io pages like http://zulily.github.io/react-datum/docs/examples
//
// this file is created by bumble-docs if it doesn't exist in the docs/examples dir

// EXAMPLES_METADATA is loaded by the index.html from ./examplesMetadata.js which is generated
// by bumble-docs/scripts/buildExamples.coffee
var examplesCollection = new Backbone.Collection(EXAMPLES_METADATA.demos);

// Each of the demos are wrapped in their own .html which is generated using /src/docs/exampleFile.tpl 
// It makes each of them individually debuggable. 

var DemoIframe = React.createClass({
  displayName: "DemoIframe",

  propTypes: {
    model: React.PropTypes.instanceOf(Backbone.Model)
  },
  contextTypes: {
    model: React.PropTypes.instanceOf(Backbone.Model)
  },
  render: function render() {
    var model = this.getModel();
    var srcPath = model.get('path');
    var htmlPath = srcPath.replace(/(.*)(\.jsx|\.js|\.coffee|\.cjsx)/, "$1.html");
    return React.createElement("iframe", { src: htmlPath });
  },

  getModel: function getModel() {
    return this.props.model || this.context.model;
  }
});

var ExamplesView = React.createClass({
  displayName: "ExamplesView",

  render: function render() {
    return React.createElement(
      "div",
      { id: "examplesView" },
      React.createElement(
        Rd.Collection,
        { collection: examplesCollection },
        React.createElement(
          Rd.Tilegrid,
          null,
          React.createElement(Rd.LazyPhoto, { attr: "thumbnailUrl" }),
          React.createElement(
            "h4",
            null,
            React.createElement(Rd.Text, { attr: "name" })
          ),
          React.createElement(
            "div",
            null,
            React.createElement(Rd.Text, { attr: "description", ellipsizeAt: false, displayAsHtml: true })
          )
        ),
        React.createElement(
          "div",
          { className: "content-pane" },
          React.createElement(
            Rd.SelectedModel,
            { placeholder: "Select a demo from the list on the left" },
            React.createElement(DemoIframe, null)
          )
        )
      )
    );
  },
  componentDidMount: function componentDidMount() {
    if (window && window.location && window.location.hash) {
      var idToSelect = window.location.hash.slice(1);
      _.delay(function () {
        examplesCollection.selectModelById(idToSelect);
      }, 1000);
    }
    examplesCollection.on('selectionsChanged', function () {
      var model = examplesCollection.getSelectedModels()[0];
      window.location.hash = model && model.id || "";
    });
  }

});

if (window) window.Demo = ExamplesView;else if (module) module.exports = ExamplesView;