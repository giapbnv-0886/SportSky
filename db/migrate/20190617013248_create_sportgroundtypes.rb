class CreateSportgroundtypes < ActiveRecord::Migration[5.2]
  def change
    create_table :sportgroundtypes do |t|
      t.string :name

      t.timestamps
    end
  end
end
