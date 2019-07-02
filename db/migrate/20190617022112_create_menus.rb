class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.decimal :price
      t.time :starttime
      t.time :endtime
      t.date :startday
      t.date :endday
      t.references :pitch, foreign_key:true

      t.timestamps
    end
  end
end
