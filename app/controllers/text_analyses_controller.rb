class TextAnalysesController < ApplicationController
  
  def new(words = [])
    @recording = Recording.find(params[:recording_id])
    texts = @recording.text.split("/-/-/")
    texts.each do |text|
      hash = JSON.parse(text)
      words += hash['results'][0]['tokens']
    end
    @text_analyses = TextAnalysisCollection.new(words, action_name)
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
