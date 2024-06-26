class CardsController < ApplicationController
  before_action :authenticate_user!

  def my_cards
    @cards = current_user.cards
  end


  def new_card_claim
    @card = Card.new

  end



  # def show_card
  #   # Finds the card by id
  #   @card = Card.find_by(unique_key: params[:unique_key])
    
  #   # Checks if the card belongs to the current_user
  #   if @card.user == current_user
  #     # If yes, render the show view
  #     render :show_card
  #   else
  #     # If not, redirect them with an error message
  #     redirect_to dashboard_path, alert: "Nie ste oprávnený zobraziť túto kartu !"
  #   end
  # end

  def show_card
    @card = Card.find_by(unique_key: params[:unique_key])
  
    # Redirect if the card doesn't exist or doesn't belong to the current user
    unless @card && @card.user == current_user
      redirect_to dashboard_path, alert: "Táto karta neexistuje alebo nie ste oprávnený ju zobraziť!"
      return
    end
  
    # If the card exists and belongs to the current user, render the show view is implied
  end
  

  

  # def update
  #   @card = Card.find_by(unique_key: params[:unique_key])
  
  #   # Checks if the card belongs to the current_user
  #   if @card.user == current_user
  #     # If yes, attempt to update the card with the provided parameters
  #     if @card.update(update_card_params)
  #       # If update succeeds, redirect to a success path, e.g., the card's show page
  #       redirect_to show_path(@card), notice: 'Karta bola úspešne aktualizovaná.'
  #     else
  #       # If update fails, render the edit form again
  #       render :show_card, status: :unprocessable_entity
      
  #     end
  #   else
  #     # If not, redirect them with an error message
  #     redirect_to dashboard_path, alert: "Nie ste oprávnený aktualizovať túto kartu!"
  #   end
  # end

  def update
    @card = Card.find_by(unique_key: params[:unique_key])
  
    # Redirect if the card doesn't exist
    unless @card
      redirect_to dashboard_path, alert: "Táto karta neexistuje!"
      return
    end
  
    # Proceed with your existing logic if the card exists
    if @card.user == current_user
      if @card.update(update_card_params)
        redirect_to show_path(@card), notice: 'Karta bola úspešne aktualizovaná.'
      else
        render :show_card, status: :unprocessable_entity
      end
    else
      redirect_to dashboard_path, alert: "Nie ste oprávnený aktualizovať túto kartu!"
    end
  end
  


  def cards_json
    @cards = current_user.cards
    render json: @cards.to_json(only: [:unique_key, :location, :redirect_counter,:destination_url])
  end



  def claim
  @card = Card.find_by(unique_key: params[:card][:unique_key])

  if @card.present?
    # Check if the card is already claimed by another user
    if @card.user.present? && @card.user != current_user
      flash[:alert] = "Túto kartu si už pridal iný používateľ!"
      redirect_to pridat_path # Adjust the redirection path as needed
      return # Prevent further execution
    end

    if @card.user == current_user
      flash[:alert] = "Túto kartu si už pridal!"
      redirect_to pridat_path 
      return
    end

    # Prepare update parameters, including setting the user to the current_user
    update_params = card_params.merge(user: current_user)

    if @card.update(update_params)
      flash[:notice] = "Karta bola úspešne pridaná!"
      redirect_to dashboard_path
    else
      # Validation errors from model
      render 'new_card_claim', status: :unprocessable_entity
    end
  else
    # No card found with the given unique_key
    flash.now[:alert] = "Nenašla sa žiadna karta s týmto ID!"
    @card = Card.new # Ensure the form can render without errors
    render 'new_card_claim', status: :unprocessable_entity
  end
end

  
  
    
  def unclaim
    @card = Card.find_by(unique_key: params[:unique_key])

    if @card.user == current_user
      @card.update_columns(location: nil, destination_url: 'https://ikarty.eu/pages/zaciname', user_id: nil, redirect_counter: 0)
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
