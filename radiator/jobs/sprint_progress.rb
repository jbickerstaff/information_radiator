require 'jira'

jira_credentials = JSON.parse( IO.read("assets/credentials/jira-credentials.json"))
PROJECT = "Web Rec UI"
JIRA_CONFIG = {
    :username     => jira_credentials["username"],
    :password     => jira_credentials["password"],
    :site         => jira_credentials["site"],
    :auth_type    => :basic,
    :context_path => ''
}

SCHEDULER.every '5m', :first_in => 0 do |job|
  client = JIRA::Client.new(JIRA_CONFIG)
  closed_points = client.Issue.jql("sprint in openSprints()  and project = \"#{PROJECT}\" and status = \"closed\"").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0
  total_points = client.Issue.jql("sprint in openSprints()  and project = \"#{PROJECT}\"").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0
  if total_points == 0
    percentage = 0
    moreinfo = "No sprint currently in progress"
  else
    percentage = ((closed_points/total_points)*100).to_i
    moreinfo = "#{closed_points.to_i} / #{total_points.to_i}"
  end

  send_event('sprintProgress', { title: "Sprint Progress", min: 0, value: percentage, max: 100, moreinfo: moreinfo })
end
