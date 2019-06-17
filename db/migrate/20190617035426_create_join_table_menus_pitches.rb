class CreateJoinTableMenusPitches < ActiveRecord::Migration[5.2]
  def change
    create_join_table :menus, :pitches do |t|
      t.index :menu_id
      t.index :pitch_id
    end
  end
end
