# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::RegistrationsController do
  describe 'POST /api/v1/signup' do
    let(:valid_attributes) do
      {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: 'Passw0rd',
        password_confirmation: 'Passw0rd'
      }
    end

    context 'with valid parameters' do
      it 'creates a new user' do
        expect do
          post api_v1_signup_path, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'returns a successful response' do
        post api_v1_signup_path, params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
      end

      it 'returns JSON with user details' do
        post api_v1_signup_path, params: { user: valid_attributes }
        expect(json).to include(data: a_kind_of(Hash))
        expect(json[:data]).to include(
          'id' => an_instance_of(Integer),
          'email' => 'john.doe@example.com',
          'first_name' => 'John',
          'last_name' => 'Doe'
        )
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { email: 'invalid-email' } }

      it 'does not create a new user' do
        expect do
          post api_v1_signup_path, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end

      it 'returns unprocessable entity status' do
        post api_v1_signup_path, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns JSON with errors' do
        post api_v1_signup_path, params: { user: invalid_attributes }
        expect(json[:message]).to eq("User couldn't be created successfully. Email is invalid and Password can't be blank")
      end
    end
  end

  describe 'PUT /api/v1/me' do
    let(:user) { create(:user, password: 'MyPassw0rd', password_confirmation: 'MyPassw0rd') }
    let(:valid_attributes) { { first_name: 'New First Name' } }
    let(:invalid_attributes) { { password: 'invalid_password' } }

    context 'when user is authenticated' do
      before { put api_v1_me_path, params: { user: valid_attributes }, headers: auth_headers(user) }

      context 'with valid attributes' do
        it 'updates the user' do
          expect(response).to have_http_status(:ok)
          expect(json[:data]).to include(id: user.id)
        end
      end

      context 'when updating the password' do
        let(:password_attributes) { { password: 'New_passw0rd', password_confirmation: 'New_passw0rd', current_password: 'MyPassw0rd' } }

        before { put api_v1_me_path, params: { user: password_attributes }, headers: auth_headers(user) }

        it 'updates the password' do
          expect(response).to have_http_status(:no_content)
        end
      end
    end

    context 'when user is not authenticated' do
      before { put api_v1_me_path, params: { user: valid_attributes } }

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
