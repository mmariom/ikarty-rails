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


# config/schedule.rb
every 1.day, at: '02:00 am' do
    rake "visits:summarize_daily"
end
  



every 1.day, at: '3:30 am' do # Choose a time that suits your application's low-traffic hours
    rake "cleanup:delete_old_summaries"
  end