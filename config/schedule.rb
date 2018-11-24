# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require File.expand_path(File.dirname(__FILE__) + "/environment")

rails_env = :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

every 1.day, at: "3:00 am" do
  runner "Batches::Broker.call"
end

every 1.day, at: ["9:00 am", "3:00 pm", "9:00 pm"] do
  runner "Batches::Broker.confirm_balance"
end
