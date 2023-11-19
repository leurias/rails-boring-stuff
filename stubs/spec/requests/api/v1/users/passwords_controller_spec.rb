# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::PasswordsController do
  describe 'POST api/v1/forget-password' do
    let(:user) { create(:user, email: 'test@example.com') }

    context 'with valid email' do
      let(:valid_attributes) { { email: user.email } }

      it 'returns a successful response' do
        post api_v1_forget_password_path, params: { user: valid_attributes }
        expect(response).to have_http_status(:ok)
      end

      it 'sends a reset password email' do
        allow(UserMailer).to receive(:reset_password).with(user, an_instance_of(String)).and_call_original
        post api_v1_forget_password_path, params: { user: valid_attributes }
        expect(UserMailer).to have_received(:reset_password).with(user, an_instance_of(String))
      end

      it 'returns JSON with success message' do
        post api_v1_forget_password_path, params: { user: valid_attributes }
        expect(json).to include(message: 'Password Reset Email Has Been Sent', level: 'INFO')
      end
    end

    context 'with invalid email' do
      let(:invalid_attributes) { { email: 'nonexistent@example.com' } }

      it 'returns not found status' do
        post api_v1_forget_password_path, params: { user: invalid_attributes }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT api/v1/reset-password' do
    let(:user) { create(:user) }
    let(:token) { user.send(:set_reset_password_token) }
    let(:valid_attributes) do
      {
        reset_password_token: token,
        password: 'New_password1',
        password_confirmation: 'New_password1'
      }
    end

    context 'with valid password reset token' do
      it 'returns a successful response' do
        put api_v1_reset_password_path, params: { user: valid_attributes }
        expect(response).to have_http_status(:ok)
      end

      it 'returns JSON with success message' do
        put api_v1_reset_password_path, params: { user: valid_attributes }
        expect(json).to include(message: 'Your password has been updated successfully, you can now login with your new password.',
                                level: 'INFO')
      end
    end

    context 'with invalid password reset token' do
      let(:invalid_attributes) do
        {
          reset_password_token: 'invalid_token'
        }
      end

      it 'returns unprocessable entity status' do
        put api_v1_reset_password_path, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns JSON with error messages' do
        put api_v1_reset_password_path, params: { user: invalid_attributes }
        expect(json[:message]).to eq("Password couldn't be updated. Reset password token is invalid")
      end
    end
  end
end
