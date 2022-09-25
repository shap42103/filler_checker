class RankingsController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @themes = Theme.all
    @results = Result.joins(:recording).limit(5)
  end
end
