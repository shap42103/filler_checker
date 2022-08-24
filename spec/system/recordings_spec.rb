require 'rails_helper'

RSpec.describe 'Recordings', type: :system do
  let!(:theme) { create(:theme) }
  let(:user) { create(:user) }
  let(:recording) { build(:recording, user_id: user.id, theme_id: theme.id) }

  before do
    login(user)
    start_recording()
  end

  describe '録音画面' do
    context '録音開始ボタンを押したとき' do
      it '録音が開始され、ボタンが「録音停止」に変化していること' do
        expect(page).to have_content('録音を停止する'), '録音が開始できていません'
        find('#stop-recording').click
      end
    end

    context '録音停止ボタンを押したとき' do
      it '録音が停止され、ボタンが「結果を確認する」に変化していること' do
        find('#stop-recording').click
        expect(find('#show-result').value).to eq '結果を確認する'
      end
    end

    context '結果を見るボタンを押したとき' do
      it '音声認識データのDBへの登録が成功すること' do
        find('#stop-recording').click
        regist_db(recording)
        expect(page).to have_content('音声認識が完了しました'), '録音結果の登録に失敗しました'
      end
    end
  end
end
