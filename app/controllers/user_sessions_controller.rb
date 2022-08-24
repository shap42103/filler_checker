class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create destroy]

  def new
  end

  def create
    @user = login(params[:email], params[:password])
    # このコードは審議

    if @user
      redirect_back_or_to results_path, success: t('.success')
    else
      flash.now[:danger] = t('.failed')
      render :new
    end
  end
  
  def destroy
    logout
    redirect_to root_path, success: t('.success')
  end

  private

  def session_params
    # params.require(:user_session).permit(:email, :password)
    # params.require(:user).permit(:email, :password)
  end
end
