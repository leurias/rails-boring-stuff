# frozen_string_literal: true

require 'devise/jwt/test_helpers'

module ApiHelpers
  def auth_headers(user, headers = {})
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end

  def json
    @json ||= JSON.parse(response.body).with_indifferent_access
  end
end
