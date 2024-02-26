# Rails.application.routes.draw do
#   devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions'}

#   # Set moje_karty as the root path
#   root 'users/sessions#new'
  
#   # Additional route for accessing moje_karty via /dashboard
#   get 'dashboard', to: 'cards#my_cards'

#   post 'claim', to: 'cards#claim'
  
#   get 'pridat', to: 'cards#new_card_claim'
#   get 'upravit/:unique_key', to: 'cards#show_card', as: :show
#   patch 'upravit/:unique_key', to: 'cards#update', as: :upravit


#   patch 'odstranit/:unique_key', to: 'cards#unclaim', as: :unclaim
  
# # config/routes.rb
#  get 'cards_data', to: 'cards#cards_json'



# end


# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
    # add other controllers if you have overridden them
  }, path: '', path_names: {
    sign_in: 'prihlasenie',
    sign_out: 'logout',
    password: 'forgot',
    confirmation: 'confirm',
    unlock: 'unblock',
    registration: 'registracia',
    sign_up: 'sign_up'
  }

  # Define root path
  devise_scope :user do
    root to: 'users/sessions#new'
    get 'registracia', to: 'users/registrations#new'

  end
  
  # Additional routes
  get 'dashboard', to: 'cards#my_cards'
  post 'pridat', to: 'cards#claim'
  
  get 'pridat', to: 'cards#new_card_claim'
  get 'upravit/:unique_key', to: 'cards#show_card', as: :show
  patch 'upravit/:unique_key', to: 'cards#update', as: :upravit
  patch 'odstranit/:unique_key', to: 'cards#unclaim', as: :unclaim
  
  # Example for fetching cards data
  get 'cards_data', to: 'cards#cards_json'
end





