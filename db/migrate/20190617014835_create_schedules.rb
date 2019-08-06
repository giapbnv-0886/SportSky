class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.date :date
      t.time :starttime
      t.time :endtime
      t.integer :cost
      t.references :pitch, foreign_key:true
      t.references :user, foreign_key:true
      t.references :status, foreign_key:true, default: 1

      t.timestamps
    end
  end
end
