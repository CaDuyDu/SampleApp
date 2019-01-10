class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailers.user_mailer.active")
  end

  def password_reset user
    @greeting = "Hi"
    mail to: user.email
  end
end
