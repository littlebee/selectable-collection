# selectable-collection
A lightweight mixin for Backbone.js collections that provides single and multi model selection 

This collection instance mixin provides the ability to mark models as selected and active.

There is one active model at a time and may be many selected. The collection will trigger an "activeModelChanged"
event when the active model is set via setActiveModel() method.  Current version of this component does not
support having active model that is not selected.  Calling setActiveModel on an unselected model, selects it.

example:
```javascript
  kittensCollection = new Backbone.Collection()
  SelectableCollection.mixInto(kittensCollection)
  kittensCollection.onSelectionsChanged(function(){
    alert("you selected " + kittensCollection.getSelectedModels().length + " kittens")
  })
  ...

  kittensCollection.selectModelByIndex(0)
  ...
```
When a collection is reset([]), or a selected model is removed from the collection it is no longer returned
by any of the getSelected... methods.  Only models that exist in the collection can be selected.

When a model is selected, model.selected=true.

Events triggered on collection:

  selectionsChanged       - triggered whenever selections change
  activeModelChanged      - function(activeModel){} triggered on active change

