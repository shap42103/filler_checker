class Result < ApplicationRecord
  belongs_to :recording

  validates :filler_count, presence: true

  def filler_interval
    (self.recording[:length] / self.filler_count.to_f).round(1)
  end

  def filler_interval_text
    if self.filler_count.to_i == 0
      'フィラーなし'
    else
      "#{self.filler_interval}秒に1回"
      # t('defaults.per_count')
    end
  end

  def most_frequent_filler_word
    self.most_frequent_filler.gsub('%', '')
  end
end
