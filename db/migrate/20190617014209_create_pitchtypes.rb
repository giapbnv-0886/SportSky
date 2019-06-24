class CreatePitchtypes < ActiveRecord::Migration[5.2]
  def change
    create_table :pitchtypes do |t|
      t.string :name

      t.timestamps
    end
  end
end
