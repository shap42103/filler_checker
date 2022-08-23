require 'rails_helper'

RSpec.describe 'Users', type: :model do
  describe 'バリデーション' do
    let(:user) { build(:user) }
    let(:user_blank_name) { build(:user, :blank_name) }
    let(:user_blank_email) { build(:user, :blank_email) }
    let(:user_blank_password) { build(:user, :blank_password) }
    let(:user_duplicated_email) { build(:user, :duplicated_email) }
    let(:user_unmatch_password_confirmation) { build(:user, :unmatch_password_confirmation) }

    context '異常系' do
      it 'ユーザー名がnilのときエラーとなること' do
        expect(user_blank_name.valid?).to eq false
      end
      it 'メールアドレスがnilのときエラーとなること' do
        expect(user_blank_name.valid?).to eq false
      end
      it 'メールアドレスが一意でないときエラーとなること' do
        user.save
        expect(user_duplicated_email.valid?).to eq false
      end
      it 'パスワードがnilのときエラーとなること' do
        expect(user_blank_password.valid?).to eq false
      end
      it 'パスワードとパスワード（確認）が一致してしないときエラーとなること' do
        expect(user_unmatch_password_confirmation.valid?).to eq false
      end
    end

    context '正常系' do
      it 'ユーザー名、メールアドレス、パスワード、パスワード確認が存在するときに正常に登録がされること' do
        expect(user.valid?).to eq true
        expect(user.role == 'general').to eq true
      end

      it 'ユーザー権限のデフォルト値がgeneralであること' do
        expect(user.role == 'general').to eq true
      end
    end
  end
end
