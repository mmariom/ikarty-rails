# app/mailers/custom_devise_mailer.rb

class CustomDeviseMailer < Devise::Mailer
    helper :application # includes all helpers, though you might narrow this down
    include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
    default template_path: 'users/mailer' # to make sure Devise uses your custom templates

  
   
    def reset_password_instructions(record, token, opts={})
      opts[:template_path] = 'users/mailer'
      super
    end
  
  
end
  