require "net/http"
require "json"

# WOEID for location:
# http://woeid.rosselliot.co.nz
woeid  = 2354842
query  = URI::encode "select item from weather.forecast WHERE woeid=#{woeid}&format=json"

SCHEDULER.every "15m", :first_in => 0 do |job|
  http     = Net::HTTP.new "query.yahooapis.com"
  request  = http.request Net::HTTP::Get.new("/v1/public/yql?q=#{query}")
  response = JSON.parse request.body
  results  = response["query"]["results"]

  if results
    current_condition = results["channel"]["item"]["condition"]
    current_location  = results["channel"]["location"]
    today_condition = results["channel"]["item"]["forecast"][0]
    tomorrow_condition = results["channel"]["item"]["forecast"][1]

    send_event "klimato", { location: current_location["city"], temperature: tomorrow_condition["high"], code: tomorrow_condition["code"], format: "f"}
  end
end