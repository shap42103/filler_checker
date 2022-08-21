require 'rails_helper'

RSpec.describe 'Recordings', type: :model do
  describe 'バリデーション' do
    context '異常系' do
      it '音声データが存在しないときエラーとなること' do
        
      end
      it 'テキストが存在しないときエラーとなること' do
        
      end
      it '録音時間が存在しないときエラーとなること' do
        
      end
    end

    context '正常系' do
      it '音声データ、テキスト、録音時間が存在するときに正常に登録がされること' do
        
      end
    end
  end
end
