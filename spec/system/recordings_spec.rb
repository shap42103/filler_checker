require 'rails_helper'

RSpec.describe 'Recordings', type: :system do
  # let(:) { }
  before do
    
  end
  describe '録音画面' do
    context '録音開始ボタンを押したとき' do
      it '録音が開始され、ボタンが「録音停止」に変化していること' do
        
      end
    end

    context '録音停止ボタンを押したとき' do
      it '録音が停止され、ボタンが「結果を見る」に変化していること' do

      end
    end

    context '結果を見るボタンを押したとき' do
      it '音声認識データのDBへの登録が成功すること' do

      end
    end
  end
end
