class Dashing.FoosRoom extends Dashing.Widget

 @accessor 'color', ->
  if @get('isOccupied') == "false"
   "#96bf48"
  else if @get('isOccupied') == "true"
   "#D26771"
  else
   "#999"
 @accessor 'text', ->
  if @get('isOccupied') == "true"
   "Occupied"
  else if @get('isOccupied') == "false"
   "Open"

 ready: ->
   # This is fired when the widget is done being rendered
   $(@node).css('background-color', @get('color'))

 onData: (data) ->
  $(@node).css('background-color', @get('color'))

