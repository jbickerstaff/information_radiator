require 'jira'
require 'net/http'
require 'json'

jira_credentials = JSON.parse( IO.read("assets/credentials/jira-credentials.json"))
PROJECT = "Web Rec UI"
JIRA_CONFIG = {
  :username     => jira_credentials["username"],
  :password     => jira_credentials["password"],
  :site         => jira_credentials["site"],
  :auth_type    => :basic,
  :context_path => ''
}
ISSUE_LISTS = [
  {:widget_id => 'jira_in_prog_issues', :status_id => 3}, # Lists all issues in progress
  {:widget_id => 'jira_qa_issues', :status_id => 7}   # Lists all done issues
]

# Constants (do not change)
JIRA_URI = URI.parse(JIRA_CONFIG[:site])
JIRA_ANON_AVATAR_ID = 10123
JIRA_STATUSES = {
  1 => "Open",
  3 => "In Progress",
  4 => "Reopened",
  5 => "Resolved",
  6 => "Done",
  7 => "Ready for QA"
}

# gets the view for a given view id
def get_view_for_viewid(view_id)
  http = create_http
  request = create_request("/rest/greenhopper/1.0/rapidviews/list")
  response = http.request(request)
  views = JSON.parse(response.body)['views']
  views.each do |view|
    if view['id'] == view_id
      return view
    end
  end
end

# gets the active sprint for the view
def get_active_sprint_for_view(view_id)
  http = create_http
  request = create_request("/rest/greenhopper/1.0/sprintquery/#{view_id}")
  response = http.request(request)
  sprints = JSON.parse(response.body)['sprints']
  sprints.each do |sprint|
    if sprint['state'] == 'ACTIVE'
      return sprint
    end
  end
end

# create HTTP
def create_http
  http = Net::HTTP.new(JIRA_URI.host, JIRA_URI.port)
  if ('https' == JIRA_URI.scheme)
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  return http
end

# create HTTP request for given path
def create_request(path)
  request = Net::HTTP::Get.new(JIRA_URI.path + path)
  if JIRA_CONFIG[:username]
    request.basic_auth(JIRA_CONFIG[:username], JIRA_CONFIG[:password])
  end
  return request
end



ISSUE_LISTS.each do |list_config|
  SCHEDULER.every '5m', :first_in => 0 do |job|
    issues = []
    status_name = JIRA_STATUSES[list_config[:status_id]]
    client = JIRA::Client.new(JIRA_CONFIG)
    # PROJECT =
    # begin
    client.Issue.jql("PROJECT = \"#{PROJECT}\" AND STATUS = \"#{status_name}\" AND SPRINT in openSprints()").each { |issue|
        assigneeAvatarUrl = issue.assignee.nil? ? URI.join(JIRA_URI.to_s, "secure/useravatar?avatarId=#{JIRA_ANON_AVATAR_ID}") : issue.assignee.avatarUrls["48x48"]
        assigneeName = issue.assignee.nil? ? "unassigned" : issue.assignee.name

        issues.push({
         id: issue.key,
         title: issue.summary,
         assigneeName: assigneeName,
         assigneeAvatarUrl: assigneeAvatarUrl
        })
    }




    send_event(list_config[:widget_id], { header: "WRU JIRA", issue_type: status_name, issues: issues})
  end
end