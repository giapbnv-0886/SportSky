class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.decimal :price
      t.time :starttime
      t.string :endtime
      t.date :startday
      t.date :endday

      t.timestamps
    end
  end
end
