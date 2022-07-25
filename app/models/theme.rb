class Theme < ApplicationRecord
  has_many :recordings, dependent: :destroy

  validates :title, presence: true, uniqueness: true
end
