# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '@Aa123123' }
    password_confirmation { '@Aa123123' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
