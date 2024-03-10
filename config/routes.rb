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
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  
  }, path: '', path_names: {
    sign_in: 'prihlasenie',
    sign_out: 'logout',
    password: 'forgot',
    confirmation: 'confirm',
    unlock: 'unblock',
    registration: 'registracia',
    sign_up: 'sign_up'
  }

  devise_scope :user do
    root to: 'users/sessions#new'
    get 'registracia', to: 'users/registrations#new'
    get 'profil', to: 'users/registrations#edit', as: :profil
    put 'profil', to: 'users/registrations#update'
    get 'zabudnute-heslo', to: 'users/passwords#new' 
    post 'zabudnute-heslo', to: 'users/passwords#create'
  end
  
  
  # Additional routes
  get 'dashboard', to: 'cards#my_cards'
  post 'claim', to: 'cards#claim'
  
  #removed because another server
  # get 'read', to: 'redirect#read'


  
  get 'pridat', to: 'cards#new_card_claim'
  get 'upravit/:unique_key', to: 'cards#show_card', as: :show
  patch 'upravit/:unique_key', to: 'cards#update', as: :upravit
  patch 'odstranit/:unique_key', to: 'cards#unclaim', as: :unclaim
  
  # Example for fetching cards data
  get 'cards_data', to: 'cards#cards_json'

  match '*unmatched_route', to: 'errors#not_found', via: :all

end





