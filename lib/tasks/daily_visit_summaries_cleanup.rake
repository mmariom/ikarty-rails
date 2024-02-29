# lib/tasks/daily_visit_summaries_cleanup.rake
namespace :cleanup do
    desc "Delete DailyVisitSummary records older than 35 days"
    task delete_old_summaries: :environment do
      cutoff_date = 36.days.ago.to_date
      deleted_count = DailyVisitSummary.where('date < ?', cutoff_date).delete_all
      puts "Deleted #{deleted_count} DailyVisitSummary records older than 35 days."
    end
  end
  