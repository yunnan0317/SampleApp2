# coding: utf-8
# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    # 临时生成一个token, 只是用来预览邮件
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset


  def password_reset
    # 临时生成一个token, 只是用来预览邮件
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end
