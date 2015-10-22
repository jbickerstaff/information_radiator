require "net/http"
require "json"

# WOEID for location:
# http://woeid.rosselliot.co.nz
woeid  = 2354842

# Units for temperature:
# f: Fahrenheit
# c: Celsius
format = "f"

query  = URI::encode "select * from weather.forecast WHERE woeid=#{woeid} and u='#{format}'&format=json"

SCHEDULER.every "15m", :first_in => 0 do |job|
  http     = Net::HTTP.new "query.yahooapis.com"
  request  = http.request Net::HTTP::Get.new("/v1/public/yql?q=#{query}")
  response = JSON.parse request.body
  results  = response["query"]["results"]

  if results
    location  = results["channel"]["location"]
    current_condition = results["channel"]["item"]["condition"]
    today_condition = results["channel"]["item"]["forecast"][0]
    tomorrow_condition = results["channel"]["item"]["forecast"][1]
    send_event "klimato", { location: location["city"], current_temperature: current_condition["temp"], current_code: current_condition["code"],
        today_high: today_condition["high"], today_low: today_condition["low"], today_text: today_condition["text"],
        tomorrow_high: tomorrow_condition["high"], tomorrow_low: tomorrow_condition["low"], tomorrow_text: tomorrow_condition["text"],
        format: format }
  end
end