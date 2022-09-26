class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :recordings, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :login_type }
  validates :email, presence: true, uniqueness: { scope: :login_type }
  validates :password, length: { minimum: 6 }, if: -> { dedicated? && (new_record? || changes[:crypted_password]) }
  validates :password, confirmation: true, if: -> { dedicated? && (new_record? || changes[:crypted_password]) }
  validates :password_confirmation, presence: true, if: -> { dedicated? && (new_record? || changes[:crypted_password]) }
  validates :reset_password_token, presence: true, uniqueness: true, allow_nil: true

  enum role: { general: 0, guest: 1, admin: 9 }
  enum login_type: { dedicated: 0, google: 1 }
end
