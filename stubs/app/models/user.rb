# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validate :password_complexity

  def name
    "#{first_name} #{last_name}"
  end

  private

  def password_complexity
    return if password.blank? || password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/)

    errors.add :password, 'must include at least one lowercase letter, one uppercase letter, and one digit'
  end
end
