class RecordingsController < ApplicationController
  def new
    @themes = Theme.all
    @recording = Recording.new
    gon.api_key = ENV['API_KEY']
  end

  def create
    @recording = current_user.recordings.new(recording_params)
    
    theme_title = theme_params[:theme].fetch(:title)
    @recording.set_theme(theme_title)

    if @recording.save
      redirect_to new_recording_text_analysis_path(@recording), success: t('.success')
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
    params.require(:recording).permit(:voice, :text, :length)
  end
  
  def theme_params
    params.require(:recording).permit(theme: [:title])
  end
end
