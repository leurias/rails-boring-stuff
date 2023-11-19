# frozen_string_literal: true

class Api::V1::Users::SessionsController < Devise::SessionsController
  include ApiResponders
  include RackSessionsFix

  respond_to :json

  wrap_parameters :user

  def create
    self.resource = warden.authenticate(auth_options)
    if resource.present?
      sign_in(resource_name, resource)
      json_response(Api::V1::UserSerializer.new(resource).serialize)
    else
      json_message('Invalid email or password. Try again.', :ERROR, :unauthorized)
    end
  end

  def respond_to_on_destroy
    json_message('You are logged out. See you soon!', :INFO)
  end
end
