class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'

  def reset_password_email(user)
    @user = User.find(user.id)
    @url = edit_password_reset_url(@user.reset_password_token) # tokenに応じたURLを生成する。
    mail(to: user.email, subject: t('user_mailer.reset_password_email.subject'))
  end
end
