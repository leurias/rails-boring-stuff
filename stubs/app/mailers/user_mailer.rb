# frozen_string_literal: true

class UserMailer < ActionMailer::Base
  default from: 'default@mydomain.com'
  layout 'mailer'

  def reset_password(user, reset_password_token)
    @user = user
    @reset_password_token = reset_password_token
    mail(to: email_address_with_name(@user.email, @user.name),
         subject: 'Rest Password Instructions',
         template_path: 'emails/users',
         template_name: 'reset_password')
  end
end
