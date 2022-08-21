require 'rails_helper'

RSpec.describe 'Results', type: :system do
  # let(:) { }
  before do

  end
  describe '解析データの集計' do
    context '結果登録画面が表示されたとき' do
      it '画面の要素が非表示になっていること' do

      end
      it 'フィラーの数を集計できていること' do

      end
      it '最も使われたフィラーが解析できていること' do

      end
      it 'DBへの登録処理が自動で行われること' do

      end
      it '結果詳細画面へリダイレクトされること' do

      end
    end
  end

  describe '結果一覧画面' do
    context '結果一覧画面が表示されたとき' do
      it '他のユーザーの結果が表示されないこと' do

      end
      it 'テーマが表示されていること' do

      end
      it 'フィラー回数が表示されていること' do

      end
      it 'フィラー頻度が表示されていること' do

      end
    end
  end

  describe '結果詳細画面' do
    context '結果詳細画面が表示されたとき' do
      it 'フィラー回数が表示されていること' do

      end
      it 'フィラー頻度が表示されていること' do

      end
      it '最頻出フィラーが表示されていること' do

      end
    end
  end
end
