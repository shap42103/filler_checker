class RankingsController < ApplicationController
  def index
    @themes = Theme.all
    @results = Result.joins(:recording).limit(5)
  end
end
