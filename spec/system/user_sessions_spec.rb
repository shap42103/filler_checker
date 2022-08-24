require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  before do
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'password'
  end

  describe 'ユーザーログイン画面' do
    context 'ユーザー名とパスワードが正しいとき' do
      it 'ログインユーザーの結果一覧に遷移すること' do
        click_button 'ログイン'
        expect(page).to have_content('ログインしました'), 'ユーザーログインに失敗しました'
        expect(page).to have_content('録音の記録'), 'ログインユーザーの結果一覧に遷移していません'
      end
    end
    
    context 'メールアドレスが間違っているとき' do
      it 'ログインに失敗すること' do
        fill_in 'email', with: 'wrong@example.com'
        click_button 'ログイン'
        expect(page).to have_content('ログインに失敗しました'), 'ログインエラーが発生していません'
        expect(find('.h2')).to have_content('ログイン'), 'ログイン画面がレンダリングされていません'
      end
    end

    context 'パスワードが間違っているとき' do
      it 'ログインに失敗すること' do
        fill_in 'password', with: 'wrong_password'
        click_button 'ログイン'
        expect(page).to have_content('ログインに失敗しました'), 'ログインエラーが発生していません'
        expect(find('.h2')).to have_content('ログイン'), 'ログイン画面がレンダリングされていません'
      end
    end
  end
end
