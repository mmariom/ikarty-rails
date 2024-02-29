class VisitsController < ApplicationController
    before_action :authenticate_user!


    def index
      @yesterday_summary = DailyVisitSummary.where(date: Date.yesterday)
      @last_7_days_summary = DailyVisitSummary.where(date: 8.days.ago..Date.yesterday)
      @last_14_days_summary = DailyVisitSummary.where(date: 15.days.ago..Date.yesterday)
      @last_30_days_summary = DailyVisitSummary.where(date: 31.days.ago..Date.yesterday)
    end
  
end
  