class AddColumnLoginTypeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :login_type, :integer, default: 0, null: false
  end
end
