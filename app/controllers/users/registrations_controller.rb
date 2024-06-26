# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  layout :determine_layout




  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)
    puts resource.errors.full_messages.inspect

    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)

        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
        
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      # The line below prevents redirection to root, rendering 'new' with errors
      render 'new'
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource

  
  def update
    super do |resource|
      if resource.errors.empty?
        # Directly specify the redirect path here, for example:
        redirect_to profil_path, notice: 'Profil bol úspešne aktualizovaný!' and return
      else
        render 'edit' , status: :unprocessable_entity and return
      end
      # No need for an else block, as Devise handles the rendering of :edit view if there are validation errors
    end
  end
  

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  protected

# If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :password, :password_confirmation, :current_password])
  end


  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    dashboard_path
  end

  # def after_update_path_for(resource)
  #   profile_path
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end


  private

  def determine_layout
    if action_name == 'edit' || action_name == 'update'
      'application'
    else
      'auth'
    end
  end

end


