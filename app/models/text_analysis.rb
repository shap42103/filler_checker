class TextAnalysis < ApplicationRecord
  belongs_to :recording

  validates :word, presence: true
  validates :filler, presence: true
end
