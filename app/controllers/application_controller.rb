class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login, :require_account

  def require_account
    if current_user&.guest?
      logout
      redirect_to new_user_path, danger: t('defaults.message.require_account') 
    end
  end

  private

  def not_authenticated
    redirect_to login_path, danger: t('defaults.message.require_login')
  end
end
