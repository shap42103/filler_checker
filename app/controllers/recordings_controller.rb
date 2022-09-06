class RecordingsController < ApplicationController
  def new
    @themes = Theme.where.not(title: t('defaults.uploaded_voice'))
    @recording = Recording.new
    gon.api_key = ENV['API_KEY']
  end

  def create
    @recording = current_user.recordings.new(recording_params)
    if @recording.audio.attached?
      if recording_params[:theme]
        theme_title = theme_params[:theme].fetch(:title)
      else
        theme_title = t('defaults.uploaded_voice')
      end
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
      render :new
    end
  end

  def show
    @result = Result.find_by(recording_id: params[:id])
  end

  private

  def recording_params
    params.require(:recording).permit(:voice, :text, :length, :audio)
  end
  
  def theme_params
    params.require(:recording).permit(theme: [:title])
  end
end
