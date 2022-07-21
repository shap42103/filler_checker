class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, null: false
    add_index :users, :name, unique: true
    add_column :users, :role, :integer, default: 0, null: false
    add_column :users, :avatar, :string
  end
end
