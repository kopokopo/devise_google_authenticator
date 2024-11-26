class Devise::DisplayqrController < DeviseController
  layout :dynamic_layout
  prepend_before_action :authenticate_scope!, only: [:show, :update, :refresh]

  include Devise::Controllers::Helpers

  # GET /resource/displayqr
  def show
    if resource.nil? || resource.gauth_secret.nil?
      sign_in resource_class.new, resource
      redirect_to stored_location_for(scope) || :root
    else
      @tmpid = resource.assign_tmp
      render :show
    end
  end

  def update
    if resource.gauth_tmp != params[resource_name]['tmpid'] || !resource.validate_token(params[resource_name]['gauth_token'])
      set_flash_message(:error, :invalid_token)
      render :show and return
    end

    if resource.set_gauth_enabled(params[resource_name]['gauth_enabled'])
      set_flash_message :notice, (resource.gauth_enabled? ? :enabled : :disabled)
      sign_in scope, resource, bypass_sign_in: true
      if params[resource_name]['invalidate_session'] == '1'
        sign_out resource
        redirect_to new_user_session_path
      else
        redirect_to stored_location_for(scope) || after_sign_in_path_for(resource)
        flash[:notice] = 'Congratulations! You are now registered for 2-factor authentication. You will be required to enter the code next time you log in.' if resource.is_a?(User)
      end
    else
      render :show
    end
  end

  def refresh
    if resource.nil?
      redirect_to :root
    else
      resource.send(:assign_auth_secret)
      resource.save
      set_flash_message :notice, :newtoken
      sign_in scope, resource, bypass_sign_in: true
      redirect_to [resource_name, :displayqr]
    end
  end

  private
  def scope
    resource_name.to_sym
  end

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end

  # 7/2/15 - Unsure if this is used anymore - @xntrik
  def resource_params
    return params.require(resource_name.to_sym).permit(:gauth_enabled) if strong_parameters_enabled?
    params
  end

  def strong_parameters_enabled?
    defined?(ActionController::StrongParameters)
  end

  def dynamic_layout
    if resource.is_a?(User)
      'application'
    elsif resource.is_a?(SaasAdmin)
      'k2admin'
    end
  end
end
