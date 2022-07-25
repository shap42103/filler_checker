class CreateThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :themes do |t|
      t.string :title, unique: true, null: false

      t.timestamps
    end
  end
end
