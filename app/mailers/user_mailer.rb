class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: @user.email, subject: t("activation.subject")
  end

  def password_reset user
    @user = user
    mail to: @user.email, subject: t("forgot_password.subject")
  end
end
