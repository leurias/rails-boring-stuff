# frozen_string_literal: true

module ApiResponders
  extend ActiveSupport::Concern

  private

  def json_message(message, level = 'INFO', http_status = :ok)
    render json: { message:, level: }, status: http_status
  end

  def json_response(resource, http_status = :ok)
    render json: resource, status: http_status
  end
end
