class ResultsController < ApplicationController
  def index
    if current_user.guest?
      redirect_to root_path, danger: t('defaults.message.require_user_registration')
    else
      @results = Result.joins(:recording).where("recordings.user_id = ?", current_user.id).order(created_at: :desc)
    end
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
      redirect_to recording_result_path(result_params[:recording_id], 1), success: t('defaults.message.successed_analyze')
    else
      flash.now[:danger] = t('.failed')
      redirect_to new_recording_path, danger: t('defaults.message.failed_analyze')
    end
  end

  def show
    @recording = Recording.find(params[:recording_id])
    @result = Result.find_by(recording_id: @recording.id)
    redirect_to results_path, danger: t('.unauthorized') unless @recording.user_id == current_user.id
  end

  private

  def result_params
    params.require(:result).permit(:recording_id, :filler_count, :most_frequent_filler)
  end
end
