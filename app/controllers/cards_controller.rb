class CardsController < ApplicationController
  before_action :authenticate_user!, only: [:new_card_claim, :claim, :unclaim, :my_cards]


  def my_cards
    @cards = current_user.cards
  end


  def new_card_claim
    @card = Card.new

  end



  def show_card
    # Finds the card by id
    @card = Card.find_by(unique_key: params[:unique_key])
    
    # Checks if the card belongs to the current_user
    if @card.user == current_user
      # If yes, render the show view
      render :show_card
    else
      # If not, redirect them with an error message
      redirect_to dashboard_path, alert: "Nie ste oprávnený zobraziť túto kartu !"
    end
  end


  def update
    @card = Card.find_by(unique_key: params[:unique_key])
  
    # Checks if the card belongs to the current_user
    if @card.user == current_user
      # If yes, attempt to update the card with the provided parameters
      if @card.update(update_card_params)
        # If update succeeds, redirect to a success path, e.g., the card's show page
        redirect_to show_path(@card), notice: 'Karta bola úspešne aktualizovaná.'
      else
        # If update fails, render the edit form again
        render :show_card, status: :unprocessable_entity
      
      end
    else
      # If not, redirect them with an error message
      redirect_to dashboard_path, alert: "Nie ste oprávnený aktualizovať túto kartu!"
    end
  end

  def cards_json
    @cards = current_user.cards
    render json: @cards.to_json(only: [:unique_key, :location, :destination_url])
  end


  # def claim
  #   # Assuming you have a current_user method available
  #   unique_key = params[:unique_key]
  #   card = Card.find_by(unique_key: unique_key)

  #   if card.present?
  #     if card.user.nil?
  #       card.update(user: current_user)
  #       flash[:notice] = "Karta bola úspešne pridaná !"
  #     else
  #       flash[:alert] = "Túto kartu si už pridal iný používateľ !"
  #     end
  #   else
  #     flash[:alert] = "Nenašla sa žiadna karta s týmto ID !"
  #   end

  #   redirect_to dashboard_path
  # end

  def claim
    @card = Card.find_by(unique_key: params[:card][:unique_key])
    
    if @card.present?
      # Prepare update parameters, including setting the user to the current_user
      update_params = card_params.merge(user: current_user)
      
      if @card.update(update_params)
        flash[:notice] = "Karta bola úspešne pridaná!"
        redirect_to dashboard_path
      else
        # Validation errors from model
        flash[:error] = @card.errors.full_messages.join(", ")
        redirect_to pridat_path
      end
    else
      flash[:alert] = "Nenašla sa žiadna karta s týmto ID!"
      redirect_to pridat_path 
    end
  end
  
  
    
  def unclaim
    @card = Card.find_by(unique_key: params[:unique_key])

    if @card.user == current_user
      @card.update_columns(location: nil, destination_url: nil,user_id: nil)
      redirect_to(dashboard_path, status:  :see_other, notice: 'Karta bola úspešne odstránená.')
      
    else
      redirect_to cards_path, alert: 'Nemáte oprávnenie na odstránenie tejto karty.'
    end
  end

  private
  def update_card_params
    params.require(:card).permit(:location, :destination_url)
  end

  def card_params
    params.require(:card).permit(:unique_key, :location, :destination_url)
  end


  
end
