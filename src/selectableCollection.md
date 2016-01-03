Instance mixins that provides selection state to collection models.

When a collection is `reset([])`, or a selected model is removed from the collection it is no longer returned
by any of the getSelected... methods.  Only models that exist in the collection can be selected.

When a model is selected, model.selected=true.

#### Events triggered on collection

  selectionsChanged       - triggered whenever selections change
  activeModelChanged      - function(activeModel){} triggered on active change

#### Instance variables added to collection
  
  hasSelectableCollection  - set to true on call to `SelectableCollection.applyTo()`  if set to true,
    calling SelectableCollection.applyTo() has no effect. 
    

