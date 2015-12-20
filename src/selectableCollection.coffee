_ = require('underscore')


# see ./selectableCollection.md 
module.exports = class SelectableCollection

  ###
    This method is used to mix SelectableCollection features into a Backbone Collection
  ###
  @applyTo: (collection) ->
    # escape hatch if we or someone else has grabbed this reponsibility.   If you want to have
    # you own compatible selectable collection functionality, you can set
    # hasSelectableCollectionMixin to true in the class prototype definition and we will not mix in.
    return if @hasSelectableCollectionMixin

    @warnIfReplacingMethods(collection)
    _.extend collection, @prototype


  @warnIfReplacingMethods: (collection) ->
    intersect = _.intersection(_.keys(collection), _.keys(@prototype))
    return unless intersect.length > 0
    # should give a stack trace everywhere
    console.error "Warning: using SelectableCollection mixin will replace the following methods: " +
      intersect.join(', ')


  # this provides an easy way for widgets, etc to see if the collection has this mixin
  hasSelectableCollectionMixin: true


  # returns
  getSelectedModels: () ->
    _.filter @models, (m) -> m.selected


  # note the special value "toggle" for selected parameter applies to all selectModel... methods
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


  selectModelById: (id, selected=true, options={}) =>
    return @selectModel @get(id), selected, options


  selectModelByIndex: (index, selected=true, options={}) =>
    return @selectModel @models[index], selected, options


  selectAll: (options={}) =>
    options = _.defaults options,
      silent: false

    for model in @models
      continue unless model?
      @selectModel(model, true, silent: true)

    @trigger 'selectionsChanged' unless options.silent


  selectNone: (options={}) =>
    options = _.defaults options,
      silent: false

    for model in @getSelectedModels()
      continue unless model?
      @selectModel model, false, silent: true

    @trigger('activeModelChanged', null)
    @trigger 'selectionsChanged' unless options.silent


  getActiveModel: () =>
    return @activeModel


  setActiveIndex: (index, options={}) =>
    @setActiveModel @models[index]


  setActiveModelById: (modelId, options={}) =>
    @setActiveModel(@get(modelId), options)


  # pass in null for model to unset active model
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
