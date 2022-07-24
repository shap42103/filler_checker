class Result < ApplicationRecord
  belongs_to :recording

  validates :filler_count, presence: true
end
