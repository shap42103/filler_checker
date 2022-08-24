require 'rails_helper'

RSpec.describe 'Results', type: :system do
  let!(:theme) { create(:theme) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user, :other_user) }
  let(:recording) { create(:recording, user_id: user.id, theme_id: theme.id) }
  let(:recording_other_user) { create(:recording, user_id: other_user.id, theme_id: theme.id) }
  let!(:result_other_user) { create(:result, recording_id: recording_other_user.id) }

  before do
    login(user)
    start_recording()
    find('#stop-recording').click
    regist_db(recording)
  end

  describe '結果一覧画面' do
    before do
      visit results_path
    end

    context '結果一覧画面が表示されたとき' do
      it '他のユーザーの結果が表示されないこと' do
        expect(find('#result-table-body')).not_to have_content('other_user'), '自分以外のユーザーが表示されています'
      end
      it 'テーマが表示されていること' do
        expect(find('#result-table-body')).to have_content('話題'), 'テーマが表示されていません'
      end
      it 'フィラー回数が表示されていること' do
        expect(find('#result-table-body')).to have_content('3'), 'フィラー回数が表示されていません'
      end
      it 'フィラー頻度が表示されていること' do
        expect(find('#result-table-body')).to have_content('秒に１回'), 'フィラー頻度が表示されていません'
      end
    end
  end

  describe '結果詳細画面' do
    context '結果詳細画面が表示されたとき' do
      it 'フィラー回数が表示されていること' do
        expect(page.all('.card-body')[0].text).to include '計 3 回'
      end
      it 'フィラー頻度が表示されていること' do
        expect(page.all('.card-body')[0].text).to include '20.0秒に１回'
      end
      it '最頻出フィラーが表示されていること' do
        expect(page.all('.card-body')[1].text).to eq '「えーと」'
      end
      it '他人の分析結果詳細にアクセスできないこと' do
        visit recording_result_path(recording_other_user, 1)
        expect(page).to have_content('権限がありません')
        expect(page).not_to have_content('分析結果')
      end
    end
  end
end
