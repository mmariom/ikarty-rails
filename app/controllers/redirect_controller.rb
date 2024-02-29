class RedirectController < ApplicationController
    
    layout 'redirect', only: [:read] 

  

    # def read
    #   @card = Card.find_by(unique_key: params[:id])
    #   if @card.nil?
    #     flash.now[:alert] = 'Karta sa nenašla !'
    #   elsif @card.destination_url.blank? # Checking if destination_url is blank
    #     flash.now[:alert] = '	URL adresa presmerovania je prázdna !'
    #     @card = nil # Ensuring @card is not used in the view
    #   end
    #     @card.visits.create
    #   # No explicit rendering; it will automatically render read.html.erb
    # end
        
    def read
      @card = Card.find_by(unique_key: params[:id])
      if @card.nil?
        flash.now[:alert] = 'Karta sa nenašla !'
      elsif @card.destination_url.blank? # Checking if destination_url is blank
        flash.now[:alert] = 'URL adresa presmerovania je prázdna !'
        @card = nil # Ensuring @card is not used in the view
      else
        # This line is moved inside the else block to ensure it only executes when there's a card with a destination URL
        @card.visits.create
      end
      # No explicit rendering; it will automatically render read.html.erb
    end
    
  end
  