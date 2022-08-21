require 'rails_helper'

RSpec.describe 'Users', type: :model do
  describe 'バリデーション' do
    context '異常系' do
      it 'ユーザー名が存在しないときエラーとなること' do
        
      end
      it 'メールアドレスが存在しないときエラーとなること' do
        
      end
      it 'メールアドレスが一意でないときエラーとなること' do
        
      end
      it 'パスワードが存在しないときエラーとなること' do
        
      end
      it 'パスワードとパスワード（確認）が一致してしないときエラーとなること' do
        
      end
    end

    context '正常系' do
      it 'ユーザー名、メールアドレス、パスワード、パスワード確認が存在するときに正常に登録がされること' do
        
      end
    end
  end
end
