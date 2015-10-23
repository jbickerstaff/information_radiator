class Dashing.FoosRoom extends Dashing.Widget

 @accessor 'color', ->
  if @get('isOccupied') == "false"
   "#49E20E"
  else if @get('isOccupied') == "true"
   "#E33638"
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

