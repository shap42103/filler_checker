class TextAnalysesController < ApplicationController
  
  def new
    @recording = Recording.find(params[:recording_id])
    @hash = JSON.parse(@recording.text)
    @words = @hash['results'][0]['tokens']
    @text_analyses = TextAnalysisCollection.new(@words, action_name)
  end
  
  def create
    @recording = Recording.find(params[:recording_id])
    @text_analyses = TextAnalysisCollection.new(text_analysis_params, action_name)
    if @text_analyses.save
      redirect_to new_recording_result_path(params[:recording_id])
    else
      flash.now[:danger] = t('.failed')
      render :new
    end
  end
end

private

def text_analysis_params
  params.require(:text_analyses)
end
