require 'rails_helper'

RSpec.describe 'Results', type: :model do
  describe 'バリデーション' do
    let(:theme) { create(:theme) }
    let(:user) { create(:user) }
    let(:recording) { create(:recording, user_id: user.id, theme_id: theme.id) }
    let(:result) { build(:result, recording_id: recording.id) }
    let(:result_zero_filler_count) { build(:result, :zero_filler_count, recording_id: recording.id) }
    let(:result_blank_filler_count) { build(:result, :blank_filler_count, recording_id: recording.id) }

    context '異常系' do
      it 'フィラー回数がnilのときエラーとなること' do
        expect(result_blank_filler_count.valid?).to eq false
      end
    end
    
    context '正常系' do
      it 'フィラー回数、最頻出フィラーが存在するときに正常に登録がされること' do
        expect(result.valid?).to eq true
      end
      it 'フィラー回数が０回でも正常に登録がされること' do
        expect(result_zero_filler_count.valid?).to eq true
      end
    end
  end
end
