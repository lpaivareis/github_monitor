class CreateRepositoryContributor < ActiveRecord::Migration[8.0]
  def change
    create_table :repository_contributors do |t|
      t.references :repository, null: false, foreign_key: true, index: true
      t.references :contributor, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
