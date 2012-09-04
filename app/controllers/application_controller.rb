class ApplicationController < ActionController::Base
  protect_from_forgery
  require 'csv'

  def date_to_db(date)
    if date.match(/\//)
      return db_date = Date.strptime(date, "%m/%d/%y").to_s("%Y-%m-%d")
    else
      return date
    end
  end
end
