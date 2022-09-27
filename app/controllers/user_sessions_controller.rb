class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create destroy]
  skip_before_action :require_account, only: %i[destroy]

  def new
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to results_path, success: t('.success')
    else
      flash.now[:danger] = t('.failed')
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    logout
    redirect_to root_path, success: t('.success')
  end
end
