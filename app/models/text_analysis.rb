class TextAnalysis < ApplicationRecord
  belongs_to :recording

  validates :word, presence: true

  def self.filler_count
    hash = self.group(:filler).count
    hash.values_at(true)[0]
  end

  def self.most_frequent_filler
    # nilのときの処理を追加しないとエラーになる
    word_count = self.group(:word).group(:filler).size
    filler_word_count = word_count.select {|key, val| key[1] == true}
    most_frequent_filler = filler_word_count.sort {|a,b| b[1]<=>a[1]}[0]
    [[:word, most_frequent_filler[0][0]], [:count, most_frequent_filler[1]]].to_h
  end

end
