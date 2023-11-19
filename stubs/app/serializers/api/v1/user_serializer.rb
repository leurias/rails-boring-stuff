# frozen_string_literal: true

module Api
  module V1
    class UserSerializer < AbstractSerializer
      attributes :id, :first_name, :last_name, :email
    end
  end
end
