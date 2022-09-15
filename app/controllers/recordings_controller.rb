class RecordingsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @themes = Theme.where.not(title: t('defaults.uploaded_voice'))
    @recording = Recording.new
    gon.api_key = ENV['API_KEY']
  end

  def create
    guest_login() unless logged_in?
    @recording = current_user.recordings.new(recording_params)

    if @recording.audio.attached? && !recording_params[:theme]
      theme_title = t('defaults.uploaded_voice') # 添付あり＆テーマ未指定 のとき
    else
      theme_title = theme_params[:theme].fetch(:title) # 添付あり＆テーマ指定 or 添付なし のとき
    end
    @recording.set_theme(theme_title)

    if @recording.parse_base64
      @recording.voice = 'recorded'
    else
      @recording.voice = 'uploaded'
    end

    if @recording.save
      redirect_to new_recording_text_analysis_path(@recording)
    else
      @themes = Theme.all
      render :new, status: :unprocessable_entity
    end
  end

  private

  def recording_params
    params.require(:recording).permit(:voice, :text, :length, :audio)
  end
  
  def theme_params
    params.require(:recording).permit(theme: [:title])
  end
end
