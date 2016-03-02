# -*- coding: utf-8 -*-
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    # 调用byebug可以用一下代码, 测试一下吧
    # debugger
  end

  def new
    @user = User.new
  end

  def create
    # 不是最终实现方式
    @user = User.new(user_params)
    if @user.save
      # 处理成功情况
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      # 重新定向到@user界面, redirect_to和render有什么区别?
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    # 为了保证安全性, 避免重置所有params, 用来创建允许修改的参数
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end
