class Dashing.JenkinsBuild extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue
  @accessor 'bgColor', ->
    if @get('currentResult') == "SUCCESS"
      "#49E20E"
    else if @get('currentResult') == "FAILURE"
      "#E33638"
    else if @get('currentResult') == "PREBUILD"
      "#ff9618"
    else
      "#999"

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".jenkins-build").val(value).trigger('change')
    @websocketurl = "ws://dashlights.corp.mybuys.com:19444"

  ready: ->
    meter = $(@node).find(".jenkins-build")
    $(@node).fadeOut().css('background-color', @get('bgColor')).fadeIn()
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))
    meter.knob()

  onData: (data) ->
    if data.currentResult isnt data.lastResult
      $(@node).fadeOut().css('background-color', @get('bgColor')).fadeIn()
      if @get('currentResult') == "SUCCESS"
        audio = new Audio('/audio/success.mp3')
        message = '{ "color": [0,255,255], "command": "color", "priority": 100 }'
        socket = new WebSocket(@websocketurl)
        socket.onopen = (evt) -> socket.send(message)
        audio.play()
      else if @get('currentResult') == "FAILURE"
        audio = new Audio('/audio/Price-is-right-losing-horn.mp3');
        message = '{"command":"effect","effect":{"name":"Snake"},"priority":100}'
        socket = new WebSocket(@websocketurl)
        socket.onopen = (evt) -> socket.send(message)
        audio.play();
      else if @get('currentResult') == "PREBUILD"
        message = '{"command":"effect","effect":{"name":"Rainbow swirl fast"},"priority":100}'
        socket = new WebSocket(@websocketurl)
        socket.onopen = (evt) -> socket.send(message)
      else
        message = '{"command":"effect","effect":{"name":"Rainbow swirl fast"},"priority":100}'
        websocketurl = "ws://169.254.210.52:19444"
        socket = new WebSocket(@websocketurl)
        socket.onopen = (evt) -> socket.send(message)