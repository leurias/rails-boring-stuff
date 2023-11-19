class Api::V1::Users::AccountsController < ApiController
  def show
    json_response(Api::V1::UserSerializer.new(current_user).serialize)
  end
end
