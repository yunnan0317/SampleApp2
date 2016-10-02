# coding: utf-8
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    assert_no_difference 'User.count' do
      post users_path, user: {
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path

    name = "Example User"
    email = "user@example.com"
    password = "password"

    assert_difference 'User.count', 1 do
      post users_path, user: {
        name: name,
        email: email,
        password: password,
        password_confirmation: password
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # 尝试在激活之前登陆
    log_in_as(user)
    assert_not is_logged_in?
    # 激活令牌无效
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # 令牌有效, 错误的邮件地址
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 激活令牌有效
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
