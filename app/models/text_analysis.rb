class TextAnalysis < ApplicationRecord
  belongs_to :recording

  validates :word, presence: true

  def self.filler_count
    hash = self.group(:filler).count
    count = hash.values_at(true)[0]
    return 0 if count.nil?
    count
  end

  def self.most_frequent_filler
    word_count = self.group(:word).group(:filler).size
    filler_word_count = word_count.select {|key, val| key[1] == true}
    if filler_word_count.present?
      most_frequent_filler = filler_word_count.sort {|a,b| b[1]<=>a[1]}[0]
      [[:word, most_frequent_filler[0][0]], [:count, most_frequent_filler[1]]].to_h
    else
      [[:word, "-"], [:count, 0]].to_h
    end
  end

end
