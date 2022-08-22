require 'rails_helper'

RSpec.describe 'Themes', type: :model do
  describe 'バリデーション' do
    let(:theme) { build(:theme) }
    let(:theme_blank_title) { build(:theme, :blank_title) }

    context '異常系' do
      it 'タイトルがnilのときエラーとなること' do
        expect(theme_blank_title.valid?).to eq false
      end
    end

    context '正常系' do
      it 'タイトルが存在するときに正常に登録がされること' do
        expect(theme.valid?).to eq true
      end
    end
  end
end
