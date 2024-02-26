# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
    layout 'auth'

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    # clean_up_passwords(resource)
    # set_minimum_password_length
    # yield resource if block_given?
  end

  # POST /resource/sign_in
  def create
    super
  end
  # def create
  #   self.resource = warden.authenticate!(auth_options)
  #   if self.resource
  #     set_flash_message!(:notice, :signed_in)
  #     sign_in(resource_name, resource)
  #     respond_with resource, location: after_sign_in_path_for(resource)
  #   else
  #     # This block is typically not needed since warden.authenticate! will throw
  #     # :warden throw if authentication fails, which is caught by Devise.
  #     # However, if you have custom logic, ensure you're setting errors on the resource
  #     # and re-rendering the 'new' template.
  #     render 'new'
  #   end
  # rescue
  #   # Ensure errors are added to the resource and 'new' template is rendered again
  #   self.resource = resource_class.new(sign_in_params)
  #   flash.now[:alert] = I18n.t('devise.failure.invalid', authentication_keys: resource_class.authentication_keys.join('/'))
  #   render 'new', layout: 'auth'
  # end

  

  # DELETE /resource/sign_out
  def destroy
    super do
      flash[:notice] = 'Úspešne ste sa odhlásili.'

      # Redirect or additional logic here, if needed
    end
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
