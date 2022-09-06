class Recording < ApplicationRecord
  has_one_attached :audio
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

  def parse_base64()
    data_tag = 'data:audio/wav;base64,'
    audio_base64 = self.voice
    
    if audio_base64.include?(data_tag)
      audio_base64 = audio_base64.gsub(data_tag, '')
      decoded_audio = Base64.decode64(audio_base64)
      filename = "#{self.user_id}_#{Time.zone.now.to_s}.wav"

      File.open("#{Rails.root}/tmp/#{filename}", 'wb') do |f|
        f.write(decoded_audio)
      end

      audio.attach(io: File.open("#{Rails.root}/tmp/#{filename}"), filename: filename)
      FileUtils.rm("#{Rails.root}/tmp/#{filename}")
      return true if audio.attached?
    end
    return false
  end

  def guest_login()
    guest_user = User.find_by(role: 'guest')
    auto_login(guest_user)
  end
end
