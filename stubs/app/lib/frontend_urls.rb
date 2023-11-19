# frozen_string_literal: true

class FrontendUrls
  FRONTEND_URLS = {
    home: '/home',
    not_found: '/404',
    reset_password: '/auth/reset-password/:reset_password_token'
  }.freeze

  def self.get(page, **params)
    frontend_url = FRONTEND_URLS[page]
    raise(ArgumentError, 'Invalid page argument') if frontend_url.nil?

    params_to_replace = frontend_url.count(':')
    raise(ArgumentError, 'Invalid parameters') if params.size != params_to_replace

    if params_to_replace.positive?
      frontend_url = params.inject(frontend_url) do |url, (param, value)|
        url.sub(":#{param}", value.to_s)
      end
    end

    Rails.configuration.frontend_base_url + frontend_url
  end
end
