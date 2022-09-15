class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  
  def new; end
    
  def create
    # email送信からリセットを要求
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    redirect_to login_path, success: t('.success') # セキュリティ考慮し常にsuccess
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    return not_authenticated if @user.blank?
  end

  def update
    # 新password入力からpassword更新を要求
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    return not_authenticated if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]
    unless params[:user][:password].blank?
      if @user.change_password(params[:user][:password])
        redirect_to login_path, success: t('.success')
        return
      end
    end
    flash.now[:danger] = t('.fail')
    render :edit, status: :unprocessable_entity
  end
end
