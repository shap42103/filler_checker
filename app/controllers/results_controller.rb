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
    not_authenticated unless @recording.user_id == current_user.id
    @tweet_url = tweet_url(@result)
  end

  private

  def result_params
    params.require(:result).permit(:recording_id, :filler_count, :most_frequent_filler)
  end

  def tweet_url(result)
    params = URI.encode_www_form({
      'url': request.base_url, 
      'text': tweet_text(result), 
      'hashtags': 'えーとチェッカー'
    })
    return "https://twitter.com/share?#{params}"
  end

  def tweet_text(result)
    texts = []
    texts[0] = "つなぎ言葉（フィラー）の回数は#{result.filler_interval_text}でした\n\n"
    
    if result.filler_interval == 9999 # never
      texts[0] = "つなぎ言葉（フィラー）はありませんでした！\n\n"
      texts[1] = "#{current_user.name}は\n一切のよどみなく人にものごとを伝えられる\nスピーチマスターです！"
    else
     if result.filler_interval < 5
      texts[1] = "#{result.most_frequent_filler_word}・・・、\n#{current_user.name}はフィラー癖が多いほうです。\n善処します"
     else
      texts[1] = "#{current_user.name}は\nたまに#{result.most_frequent_filler_word}・・・といってしまいますが、\n気になるほどではないです。"
     end
    end

    texts[2] = "\n\nえーと…を言わずに話せるか試そう！"
    return texts.sum
  end
end
