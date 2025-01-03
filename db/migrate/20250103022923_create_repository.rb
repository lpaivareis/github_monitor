class CreateRepository < ActiveRecord::Migration[8.0]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :description
      t.string :html_url
      t.string :topics, array: true, default: []
      t.integer :stars
      t.integer :forks
      t.integer :watchers

      t.timestamps

      t.references :owner, null: false, foreign_key: true, index: true
    end
  end
end
