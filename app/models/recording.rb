class Recording < ApplicationRecord
  has_many :text_analyses, dependent: :destroy
  has_many :results, dependent: :destroy
  belongs_to :user
  belongs_to :theme

  validates :voice, presence: true
  validates :text, presence: true
  validates :length, presence: true
end
