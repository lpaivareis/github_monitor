class CreateOwner < ActiveRecord::Migration[8.0]
  def change
    create_table :owners do |t|
      t.string :login, null: false
      t.string :avatar
      t.string :html_url

      t.timestamps
    end
  end
end
