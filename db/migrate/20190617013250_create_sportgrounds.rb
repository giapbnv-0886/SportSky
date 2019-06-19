class CreateSportgrounds < ActiveRecord::Migration[5.2]
  def change
    create_table :sportgrounds do |t|
      t.string :address
      t.string :name
      t.string :phone
      t.time :opentime
      t.time :closetime
      t.belongs_to :sportgroundtype,foreign_key:true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
