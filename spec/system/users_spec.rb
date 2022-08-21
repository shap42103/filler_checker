require 'rails_helper'

RSpec.describe 'Users', type: :system do
  # let(:) { }
  before do

  end
  describe 'ユーザー登録画面' do
    context 'すべての必須項目が入力されたとき' do
      it 'ユーザーが登録されること' do

      end
    end

    context 'ユーザー名が入力されていないとき' do
      it 'ユーザー名未入力のエラーが発生すること' do

      end
    end

    context 'メールアドレスが入力されていないとき' do
      it 'メールアドレス未入力のエラーが発生すること' do

      end
    end

    context 'パスワードが入力されていないとき' do
      it 'パスワード未入力のエラーが発生すること' do

      end
    end
    
    context 'パスワードが6文字未満のとき' do
      it 'パスワード文字数不足のエラーが発生すること' do
        
      end
    end

    context 'パスワード（確認）が入力されていないとき' do
      it 'パスワード（確認）未入力のエラーが発生すること' do

      end
    end

    context 'パスワード（確認）がパスワードと異なるとき' do
      it 'パスワード不一致のエラーが発生すること' do

      end
    end
  end
end
