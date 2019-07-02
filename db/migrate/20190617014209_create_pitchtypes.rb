class CreatePitchtypes < ActiveRecord::Migration[5.2]
  def change
    create_table :pitchtypes do |t|
      t.string :name
      t.references :sportgroundtype, foreign_key: true

      t.timestamps
    end
  end
end
