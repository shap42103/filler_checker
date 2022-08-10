class ResultsController < ApplicationController
  def index
    @results = Result.joins(:recording).where("recordings.user_id = ?", current_user.id)
  end

  def new
    @text_analysis = TextAnalysis.where(recording_id: params[:recording_id])
    @filler_count = @text_analysis.filler_count
    @most_frequent_filler = @text_analysis.most_frequent_filler
    @result = Result.new
  end

  def create
    @result = Result.new(result_params)
    if @result.save
      redirect_to root_path
    else
      flash.now[:danger] = t('.failed')
      render :new
    end
  end

  private

  def result_params
    params.require(:result).permit(:recording_id, :filler_count, :most_frequent_filler)
  end
end
