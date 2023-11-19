# frozen_string_literal: true

devise_for :users, skip: :all

namespace :api, defaults: { format: :json } do
  namespace :v1 do
    devise_scope :user do
      post   'login',           to: 'users/sessions#create'
      delete 'logout',          to: 'users/sessions#destroy'
      post   'signup',          to: 'users/registrations#create'
      post   'forget-password', to: 'users/passwords#create'
      put    'reset-password',  to: 'users/passwords#update'
      get    'me',              to: 'users/accounts#show'
      put    'me',              to: 'users/registrations#update'
    end
  end
end
