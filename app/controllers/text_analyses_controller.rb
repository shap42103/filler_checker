class TextAnalysesController < ApplicationController
  skip_before_action :require_account, only: %i[new create]

  def new
    @recording = Recording.find(params[:recording_id])
    hash = JSON.parse(@recording.text)
    word = hash['results'][0]['tokens']
    if word[0]&.keys.present?
      @text_analyses = TextAnalysisCollection.new(word, action_name)
    else
      redirect_to new_recording_path, danger: t('defaults.message.failed_analyze')
    end
  end
  
  def create
    @recording = Recording.find(params[:recording_id])
    @text_analyses = TextAnalysisCollection.new(text_analysis_params, action_name)
    if @text_analyses.save
      redirect_to new_recording_result_path(params[:recording_id])
    else
      flash.now[:danger] = t('.failed')
      redirect_to new_recording_path, danger: t('defaults.message.failed_analyze')
    end
  end
end

private

def text_analysis_params
  params.require(:text_analyses)
end
