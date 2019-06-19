class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.string :comment
      t.integer :rating
      t.references :sportground, foreign_key:true
      t.references :user, foreign_key:true

      t.timestamps
    end
    add_index :rates, [:sportground_id, :user_id], unique: true
  end
end
