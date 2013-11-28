namespace :schedules do
  desc "Periodically clean up the db and delete old events"
  task :remove_old, [:since] => :environment do |t, args|
    Rails.logger = Logger.new(STDOUT)
    cutoff = args[:since] || (DateTime.now - 1.week)
    Schedule.where("date_at < ?", cutoff).delete_all
  end
end
