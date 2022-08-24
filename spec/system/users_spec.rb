require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { build(:user) }

  before do
    visit new_user_path
    fill_in 'user_name', with: user.name
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
  end

  describe 'ユーザー登録画面' do
    context 'すべての必須項目が入力されたとき' do
      it 'ユーザーが登録されること' do
        click_button '新規登録'
        expect(page).to have_content('ユーザー登録が完了'), 'ユーザー登録が失敗しました'
      end
    end
    
    context 'ユーザー名が入力されていないとき' do
      it 'ユーザー名未入力のエラーが発生すること' do
        fill_in 'user_name', with: ''
        click_button '新規登録'
        expect(page).not_to have_content('ユーザー登録が完了'), 'バリデーションが機能していません'
        expect(page).to have_content('ユーザー名を入力してください'), 'エラーメッセージが正しくありません'
      end
    end

    context 'メールアドレスが入力されていないとき' do
      it 'メールアドレス未入力のエラーが発生すること' do
        fill_in 'user_email', with: ''
        click_button '新規登録'
        expect(page).not_to have_content('ユーザー登録が完了'), 'バリデーションが機能していません'
        expect(page).to have_content('メールアドレスを入力してください'), 'エラーメッセージが正しくありません'
      end
    end

    context 'パスワードが入力されていないとき' do
      it 'パスワード未入力のエラーが発生すること' do
        fill_in 'user_password', with: ''
        fill_in 'user_password_confirmation', with: ''
        click_button '新規登録'
        expect(page).not_to have_content('ユーザー登録が完了'), 'バリデーションが機能していません'
        expect(page).to have_content('パスワードは6文字以上で入力'), 'エラーメッセージが正しくありません'
      end
    end
    
    context 'パスワードが6文字未満のとき' do
      it 'パスワード文字数不足のエラーが発生すること' do
        fill_in 'user_password', with: '123'
        fill_in 'user_password_confirmation', with: '123'
        click_button '新規登録'
        expect(page).not_to have_content('ユーザー登録が完了'), 'バリデーションが機能していません'
        expect(page).to have_content('パスワードは6文字以上で入力'), 'エラーメッセージが正しくありません'
      end
    end

    context 'パスワード（確認）が入力されていないとき' do
      it 'パスワード（確認）未入力のエラーが発生すること' do
        fill_in 'user_password', with: ''
        fill_in 'user_password_confirmation', with: ''
        click_button '新規登録'
        expect(page).not_to have_content('ユーザー登録が完了'), 'バリデーションが機能していません'
        expect(page).to have_content('パスワード（確認）を入力してください'), 'エラーメッセージが正しくありません'
      end
    end

    context 'パスワード（確認）がパスワードと異なるとき' do
      it 'パスワード不一致のエラーが発生すること' do
        fill_in 'user_password_confirmation', with: 'abcdefg'
        click_button '新規登録'
        expect(page).not_to have_content('ユーザー登録が完了'), 'バリデーションが機能していません'
        expect(page).to have_content('パスワード（確認）とパスワードの入力が一致しません'), 'エラーメッセージが正しくありません'
      end
    end
  end
end
