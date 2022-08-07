class Recording < ApplicationRecord
  has_many :text_analyses, dependent: :destroy
  has_many :results, dependent: :destroy
  belongs_to :user
  belongs_to :theme

  validates :voice, presence: true
  validates :text, presence: true
  validates :length, presence: true

  def set_theme(theme_title)
    theme_id = Theme.find_by(title: theme_title)&.id
    self.theme_id = theme_id
  end
end
