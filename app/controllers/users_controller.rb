# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]


  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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
      @user.send_activation_email
      flash[:info] = "Please check you email to activate your account."
      redirect_to root_url
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # # 重新定向到@user界面, redirect_to和render有什么区别?
      # redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
    # 处理更新成功情况
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to root_url
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    # 为了保证安全性, 避免重置所有params, 用来创建允许修改的参数
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # 事前过滤器

    # 已经移动到ApplicationController中
    # 确保用户已经登陆
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Please log in."
    #     redirect_to login_url
    #   end
    # end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 确保为admin_user
    def admin_user
      redirect_to(root_url) unless current_user.respond_to?(:admin?) && current_user.admin?
    end
end
