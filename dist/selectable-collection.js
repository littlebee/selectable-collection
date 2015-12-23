(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory(require("_"));
	else if(typeof define === 'function' && define.amd)
		define(["_"], factory);
	else if(typeof exports === 'object')
		exports["SelectableCollection"] = factory(require("_"));
	else
		root["SelectableCollection"] = factory(root["_"]);
})(this, function(__WEBPACK_EXTERNAL_MODULE_3__) {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "dist/";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	module.exports = __webpack_require__(1);


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	module.exports = {

	  SelectableCollection: __webpack_require__(2)

	};

/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	var SelectableCollection, _,
	  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

	_ = __webpack_require__(3);

	module.exports = SelectableCollection = (function() {
	  function SelectableCollection() {
	    this.setActiveModel = bind(this.setActiveModel, this);
	    this.setActiveModelById = bind(this.setActiveModelById, this);
	    this.setActiveIndex = bind(this.setActiveIndex, this);
	    this.getActiveModel = bind(this.getActiveModel, this);
	    this.selectNone = bind(this.selectNone, this);
	    this.selectAll = bind(this.selectAll, this);
	    this.selectModelByIndex = bind(this.selectModelByIndex, this);
	    this.selectModelById = bind(this.selectModelById, this);
	    this.selectModel = bind(this.selectModel, this);
	  }


	  /*
	    This method is used to mix SelectableCollection features into a Backbone Collection
	   */

	  SelectableCollection.applyTo = function(collection) {
	    if (this.hasSelectableCollectionMixin) {
	      return;
	    }
	    this.warnIfReplacingMethods(collection);
	    return _.extend(collection, this.prototype);
	  };

	  SelectableCollection.warnIfReplacingMethods = function(collection) {
	    var intersect;
	    intersect = _.intersection(_.keys(collection), _.keys(this.prototype));
	    if (!(intersect.length > 0)) {
	      return;
	    }
	    return console.error("Warning: using SelectableCollection mixin will replace the following methods: " + intersect.join(', '));
	  };

	  SelectableCollection.prototype.hasSelectableCollectionMixin = true;

	  SelectableCollection.prototype.getSelectedModels = function() {
	    return _.filter(this.models, function(m) {
	      return m.selected;
	    });
	  };

	  SelectableCollection.prototype.selectModel = function(model, selected, options) {
	    if (selected == null) {
	      selected = true;
	    }
	    if (options == null) {
	      options = {};
	    }
	    options = _.defaults(options, {
	      silent: false
	    });
	    if (model == null) {
	      console.warn("SelectableCollection: selectModel called on null model");
	      return false;
	    }
	    if (selected === "toggle") {
	      model.selected = (model.selected == null) || model.selected === false;
	    } else {
	      model.selected = selected;
	    }
	    if (!options.silent) {
	      this.trigger('selectionsChanged');
	    }
	    return model.selected;
	  };

	  SelectableCollection.prototype.selectModelById = function(id, selected, options) {
	    if (selected == null) {
	      selected = true;
	    }
	    if (options == null) {
	      options = {};
	    }
	    return this.selectModel(this.get(id), selected, options);
	  };

	  SelectableCollection.prototype.selectModelByIndex = function(index, selected, options) {
	    if (selected == null) {
	      selected = true;
	    }
	    if (options == null) {
	      options = {};
	    }
	    return this.selectModel(this.models[index], selected, options);
	  };

	  SelectableCollection.prototype.selectAll = function(options) {
	    var i, len, model, ref;
	    if (options == null) {
	      options = {};
	    }
	    options = _.defaults(options, {
	      silent: false
	    });
	    ref = this.models;
	    for (i = 0, len = ref.length; i < len; i++) {
	      model = ref[i];
	      if (model == null) {
	        continue;
	      }
	      this.selectModel(model, true, {
	        silent: true
	      });
	    }
	    if (!options.silent) {
	      return this.trigger('selectionsChanged');
	    }
	  };

	  SelectableCollection.prototype.selectNone = function(options) {
	    var i, len, model, ref;
	    if (options == null) {
	      options = {};
	    }
	    options = _.defaults(options, {
	      silent: false
	    });
	    ref = this.getSelectedModels();
	    for (i = 0, len = ref.length; i < len; i++) {
	      model = ref[i];
	      if (model == null) {
	        continue;
	      }
	      this.selectModel(model, false, {
	        silent: true
	      });
	    }
	    this.trigger('activeModelChanged', null);
	    if (!options.silent) {
	      return this.trigger('selectionsChanged');
	    }
	  };

	  SelectableCollection.prototype.getActiveModel = function() {
	    return this.activeModel;
	  };

	  SelectableCollection.prototype.setActiveIndex = function(index, options) {
	    if (options == null) {
	      options = {};
	    }
	    return this.setActiveModel(this.models[index]);
	  };

	  SelectableCollection.prototype.setActiveModelById = function(modelId, options) {
	    if (options == null) {
	      options = {};
	    }
	    return this.setActiveModel(this.get(modelId), options);
	  };

	  SelectableCollection.prototype.setActiveModel = function(model, options) {
	    var currentActive;
	    if (options == null) {
	      options = {};
	    }
	    options = _.defaults(options, {
	      active: true,
	      silent: false
	    });
	    currentActive = this.getActiveModel();
	    if (currentActive != null) {
	      currentActive.active = false;
	    }
	    this.selectModel(model, options);
	    if (model != null) {
	      model.active = options.active;
	    }
	    this.activeModel = model;
	    if (!options.silent) {
	      return this.trigger('activeModelChanged', model);
	    }
	  };

	  return SelectableCollection;

	})();


/***/ },
/* 3 */
/***/ function(module, exports) {

	module.exports = __WEBPACK_EXTERNAL_MODULE_3__;

/***/ }
/******/ ])
});
;