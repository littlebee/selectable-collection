_ = require('underscore')


# see ./selectableCollection.md 
module.exports = class SelectableCollection

  ###
    This method is used to mix SelectableCollection features into a Backbone Collection.
    
    example:
    ```javascript
      kittensCollection = new Backbone.Collection()
      SelectableCollection.applyTo(kittensCollection)
    ```
  ###
  @applyTo: (collection) ->
    return if collection.hasSelectableCollectionMixin
    collection.hasSelectableCollection = true

    @warnIfReplacingMethods(collection)
    _.extend collection, @prototype


  @warnIfReplacingMethods: (collection) ->
    intersect = _.intersection(_.keys(collection), _.keys(@prototype))
    return unless intersect.length > 0
    # should give a stack trace everywhere
    console.error "Warning: using SelectableCollection mixin will replace the following methods: " +
      intersect.join(', ')

  #  This instance var is added to the collection to indicate that it has this mixin or a 
  #  compatible mixin providing the feature of SelectableCollection
  hasSelectableCollectionMixin: true


  ###
    Collection instance method that returns an array of selected models
  ###
  getSelectedModels: () ->
    _.filter @models, (m) -> m.selected


  ###
    Collection instance method that selects a single model.
   
    The model will be given a `selected` property of true.
   
    The `selected` argument can be one of:
    `true`    - model argument will be selected
    `false`   - unselect model
    "toggle"` - invert current selected state
    
    Example: 
    ```javascript
      myCollection.selectModel(myModel)
      console.log(myModel.selected)
      # => true
    ```  
    
  ###
  selectModel: (model, selected=true, options={}) =>
    options = _.defaults options,
      silent: false

    unless model?
      console.warn "SelectableCollection: selectModel called on null model"
      return false

    if selected == "toggle"
      model.selected = !model.selected? || model.selected == false
    else
      model.selected = selected

    @trigger 'selectionsChanged' unless options.silent

    return model.selected

  ###
    Collection instance method that selects a single model by ID.
    
    collection.get(id) is used to get the model passed to selectModel method.
    
    See also [selectModel method](#selectModel) for options
  ###
  selectModelById: (id, selected=true, options={}) =>
    return @selectModel @get(id), selected, options


  ###
    Collection instance method that selects a single model by it's zero based index
    in the collection.

    See also [selectModel method](#selectModel) for options
  ###
  selectModelByIndex: (index, selected=true, options={}) =>
    return @selectModel @models[index], selected, options


  ###
    Collection instance method that selects all models in the collection.

    A single *selectionsChanged* event is triggered unless options.silent==true 
  ###
  selectAll: (options={}) =>
    options = _.defaults options,
      # if true, no selectionsChanged events are triggered
      silent: false

    for model in @models
      continue unless model?
      @selectModel(model, true, silent: true)

    @trigger 'selectionsChanged' unless options.silent


  ###
    Collection instance method that unselects all models.  Also sets activeModel to null.

    A *selectionsChanged* event is triggered unless options.silent==true. 
    A *activeModelChanged* event is also fired
  ###
  selectNone: (options={}) =>
    options = _.defaults options,
      # if true, no selectionsChanged events are triggered
      silent: false

    for model in @getSelectedModels()
      continue unless model?
      @selectModel model, false, silent: true
    
    @trigger('selectionsChanged') unless options.silent
    
    @setActiveModel(null)

  ###
    Collection instance method that sets the current 'active' Model.  Multiple models may be 
    selected in the collection, only one model can be 'active'.   The active model is also
    selected in the collection if not already selected.  
    
    SetActiveModel() is an optional feature. Active model can be used, as it is by 
    [tilegrid](https://github.com/zulily/tilegrid), to provide both multiple selections and
    a single selection within that set (the last tile added to the selections)
      
    pass in null for model argument to unset active model
  ###
  setActiveModel: (model, options={}) =>
    options = _.defaults options,
      active: true
      silent: false

    currentActive = @getActiveModel()
    currentActive?.active = false
    @selectModel model, options
    model?.active = options.active
    @activeModel = model
    @trigger('activeModelChanged', model) unless options.silent

  ###
    Collection instance method that returns the current active model.  
  ###
  getActiveModel: () =>
    return @activeModel

  ###
    Collection instance method that sets the active model by index in collection.
    
    see [setActiveModel](#setActiveModel) for options
  ###
  setActiveIndex: (index, options={}) =>
    @setActiveModel @models[index]


  ###
    Collection instance method that sets the active model by id in collection.
    
    see [setActiveModel](#setActiveModel) for options
  ###
  setActiveModelById: (modelId, options={}) =>
    @setActiveModel(@get(modelId), options)


