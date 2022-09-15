class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :authenticated?, except: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] = t('.failed')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if current_user.update(user_params)
      redirect_to root_path, success: t('.success')
    else
      flash.now[:danger] = t('.failed')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, success: t('.success')
  end

  def change_password
    @user&.deliver_reset_password_instructions!
    redirect_to edit_user_path(@user), success: t('.success')
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def authenticated?
    @user = User.find(params[:id])
    not_authenticated unless @user.id == current_user.id
  end
end
