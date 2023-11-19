# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::AccountsController do
  describe 'GET /api/v1/me' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }

      before { get api_v1_me_path, headers: auth_headers(user) }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns JSON with user details' do
        expect(json).to include(data: a_kind_of(Hash))
        expect(json[:data]).to include(id: user.id)
      end
    end

    context 'when user is not authenticated' do
      before { get api_v1_me_path }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
