# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  include ApiResponders
  include RackSessionsFix

  respond_to :json

  wrap_parameters :user

  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update


  def create
    build_resource(sign_up_params)

    # NOTE: token = request.env['warden-jwt_auth.token']

    if resource.save
      sign_up(resource_name, resource)

      json_response(Api::V1::UserSerializer.new(resource).serialize, :created)
    else
      json_message("User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}", :ERROR, :unprocessable_entity)
    end
  end

  def update
    return json_message('Unauthorized!', :ERROR, :unauthorized) unless user_signed_in?

    # If the user is updating the password, perform the default behavior
    if account_update_params[:password].present?
      super
    else
      # If the user is not updating the password, remove the password-related params
      clean_up_passwords(resource)
      resource.update_without_password(account_update_params)
      json_response(Api::V1::UserSerializer.new(resource).serialize)
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name password_confirmation])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end
end
