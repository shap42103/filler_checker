class GoogleLoginController < ApplicationController
  require 'googleauth/id_tokens/errors'
  require 'googleauth/id_tokens/verifier'

  skip_before_action :require_login, only: %i[callback]
  protect_from_forgery except: :callback
  before_action :verify_g_csrf_token

  def callback
    if params[:credential].present?
      payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: ENV['GOOGLE_CLIENT_ID'])
      user = User.find_or_initialize_by(name: payload['name'], email: payload['email'], login_type: 'google')
      if user.save
        auto_login(user)
        redirect_to new_recording_path, success: t('.success')
        return
      end
    end
    redirect_to login_path, danger: t('.failed')
  end

  private

  def verify_g_csrf_token
    if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
      redirect_to login_path, danger: t('.invalid_request')
    end
  end
end
