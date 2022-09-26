class RemoveIndexNameEmailToUsers < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, :email
    remove_index :users, :name
  end
end
