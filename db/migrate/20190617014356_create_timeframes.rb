class CreateTimeframes < ActiveRecord::Migration[5.2]
  def change
    create_table :timeframes do |t|
      t.time :starttime
      t.time :endtime
      t.references :pitch, foreign_key:true

      t.timestamps
    end
  end
end
