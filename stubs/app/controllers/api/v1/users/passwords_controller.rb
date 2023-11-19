# frozen_string_literal: true

class Api::V1::Users::PasswordsController < Devise::PasswordsController
  include ApiResponders

  respond_to :json

  wrap_parameters :user

  def create
    return head :not_found if (email = resource_params[:email]).blank?

    user = User.where(email:).first

    return head :not_found if user.blank?

    token = user.send(:set_reset_password_token)
    UserMailer.reset_password(user, token).deliver_later

    json_message('Password Reset Email Has Been Sent', :INFO)
  end

  def update
    user = User.reset_password_by_token(resource_params)

    if user.errors.empty?
      json_message('Your password has been updated successfully, you can now login with your new password.', :INFO)
    else
      json_message("Password couldn't be updated. #{user.errors.full_messages.to_sentence}", :ERROR, :unprocessable_entity)
    end
  end
end
