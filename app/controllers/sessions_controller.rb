# -*- coding: utf-8 -*-
class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        # 登入用户, 定向到指定页面
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_to user
      else
        # 创建错误消息
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
      end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end