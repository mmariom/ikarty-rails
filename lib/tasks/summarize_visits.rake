# lib/tasks/summarize_visits.rake
# namespace :visits do
#     desc "Summarize yesterday's visits for each card"
#     task summarize_daily: :environment do
#       date = Date.yesterday
#       Card.includes(:visits).find_each do |card|
#         visit_count = card.visits.where(created_at: date.beginning_of_day..date.end_of_day).count
#         DailyVisitSummary.create(card: card, date: date, visit_count: visit_count)
#       end
  
#       puts "Daily visit summaries have been created for #{date}."
#     end
#   end
  

# lib/tasks/summarize_visits.rake
namespace :visits do
    desc "Summarize yesterday's visits for each card, delete them, and handle days with no visits"
    task summarize_daily: :environment do
      date = Date.yesterday
      Card.find_each do |card|
        # Count the visits for the given day
        visit_count = card.visits.where(created_at: date.beginning_of_day..date.end_of_day).count
  
        # Create a summary record with the count (can be 0 if no visits were found)
        DailyVisitSummary.create(card: card, date: date, visit_count: visit_count)
  
        # Optionally, delete the visits that have been summarized if there are any
        card.visits.where(created_at: date.beginning_of_day..date.end_of_day).delete_all if visit_count > 0
      end
  
      puts "Daily visit summaries, including days with no visits, have been processed for #{date}."
    end
  end
  
