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

See our [api docs](TODO: link to github io pages) for more information on the events and methods added to the collection.


