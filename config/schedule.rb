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
rails_env = ENV["RAILS_ENV"] || :development

set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

env :PATH, ENV["PATH"]
job_type :rbenv_runner, %q!eval "$(rbenv init -)"; cd :path && bin/rails runner -e :environment ':task' :output!

every 1.day, :at => "03:00 am" do
  rbenv_runner "Batches::Broker.call"
end
