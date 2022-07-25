class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.integer :filler_count, default: 0
      t.string :most_frequent_filler
      t.references :recording, null: false, foreign_key: true

      t.timestamps
    end
  end
end
