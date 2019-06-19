class CreateSportgrounds < ActiveRecord::Migration[5.2]
  def change
    create_table :sportgrounds do |t|
      t.string :address
      t.string :name
      t.string :phone
      t.time :opentime
      t.time :closetime
      t.references :sportgroundtype, foreign_key:true
      t.references :user, foreign_key:true, allow_nil:true

      t.timestamps
    end
  end
end
