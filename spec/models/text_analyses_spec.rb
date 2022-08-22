require 'rails_helper'

RSpec.describe 'TextAnalyses', type: :model do
  describe 'バリデーション' do
    let(:theme) { create(:theme) }
    let(:user) { create(:user) }
    let(:recording) { create(:recording, user_id: user.id, theme_id: theme.id) }
    let(:text_analysis) { build(:text_analysis, recording_id: recording.id) }
    let(:text_analysis_blank_filler) { build(:text_analysis, :blank_filler, recording_id: recording.id) }
    let(:text_analysis_blank_word) { build(:text_analysis, :blank_word, recording_id: recording.id) }

    context '異常系' do
      it '単語がnilのときエラーとなること' do
        expect(text_analysis_blank_word.valid?).to eq false
      end
      it 'フィラーがnilのときエラーとなること' do
        expect(text_analysis_blank_filler.valid?).to eq false
      end
    end
    
    context '正常系' do
      it '単語とフィラーが存在するときに正常に登録がされること' do
        expect(text_analysis.valid?).to eq true
      end
    end
  end
end
