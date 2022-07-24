class CreateTextAnalyses < ActiveRecord::Migration[7.0]
  def change
    create_table :text_analyses do |t|
      t.string :word, null: false
      t.boolean :filler, default: false
      t.references :recording, null: false, foreign_key: true

      t.timestamps
    end
  end
end
