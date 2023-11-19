# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::SessionsController do
  describe 'POST api/v1/login' do
    let(:user) { create(:user, email: 'test@example.com', password: 'Password1', password_confirmation: 'Password1') }
    let(:valid_attributes) { { email: user.email, password: 'Password1' } }
    let(:invalid_attributes) { { email: user.email, password: 'wrong_password' } }

    context 'with valid credentials' do
      before do
        post api_v1_login_path, params: { user: valid_attributes }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns JSON with user details' do
        expect(json[:data]).to include(id: user.id)
      end
    end

    context 'with invalid credentials' do
      before do
        post api_v1_login_path, params: { user: invalid_attributes }
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns JSON with error message' do
        expect(json[:message]).to eq('Invalid email or password. Try again.')
      end
    end
  end
end
