require 'rails_helper'

RSpec.describe 'Recordings', type: :model do
  describe 'バリデーション' do
    let(:theme) { create(:theme) }
    let(:user) { create(:user) }
    let(:recording) { build(:recording, user_id: user.id, theme_id: theme.id) }
    let(:recording_without_voice) { build(:recording, :blank_voice, user_id: user.id, theme_id: theme.id) }
    let(:recording_without_text) { build(:recording, :blank_text, user_id: user.id, theme_id: theme.id) }
    let(:recording_without_length) { build(:recording, :blank_length, user_id: user.id, theme_id: theme.id) }

    context '異常系' do
      it '音声データが存在しないときエラーとなること' do
        expect(recording_without_voice.valid?).to eq false
      end
      it 'テキストが存在しないときエラーとなること' do
        expect(recording_without_text.valid?).to eq false
      end
      it '録音時間が存在しないときエラーとなること' do
        expect(recording_without_length.valid?).to eq false
      end
    end

    context '正常系' do
      it '音声データ、テキスト、録音時間が存在するときに正常に登録がされること' do
        expect(recording.valid?).to eq true
      end
    end
  end
end
