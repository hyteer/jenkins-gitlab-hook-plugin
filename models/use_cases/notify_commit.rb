require_relative '../values/settings'
require_relative '../services/get_jenkins_projects'

module GitlabWebHook
  class NotifyCommit
    LOGGER = Logger.getLogger(NotifyCommit.class.name)

    attr_reader :project

    def initialize(project)
      @project = project
    end

    def call
      return "#{project} is configured to ignore notify commit, skipping scheduling for polling" if project.is_ignoring_notify_commit?
      return "#{project} is not buildable (it is disabled or not saved), skipping polling" unless project.is_buildable?

      begin
        return "#{project} scheduled for polling" if project.schedulePolling
      rescue Exception => e
        LOGGER.log(Level::SEVERE, e.message, e)
      end

      "#{project} could not be scheduled for polling, it is disabled or has no SCM trigger"
    end
  end
end