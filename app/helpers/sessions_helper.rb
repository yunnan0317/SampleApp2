# -*- coding: utf-8 -*-
module SessionsHelper

  # 登入指定用户
  def log_in(user)
    session[:user_id] = user.id
  end

  # 返回当前登陆的用户(如果有的话)
  def current_user
    # 表达式的值为最后的值, 相当于
    # if session[:user_id]
    #   user.id = session[:user_id]
    # end
    # 同样的也发生在elsif中
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 如果用户登陆, 返回true, 否则返回false
  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


  # 退出登陆
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 在持久的会话中记住用户
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 如果制定用户是当前用户, 返回true
  def current_user?(user)
    user == current_user
  end

  # 重定向到存储的地址, 或者默认地址
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # 存储以后需要获取的地址
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
