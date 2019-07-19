class CreatePitches < ActiveRecord::Migration[5.2]
  def change
    create_table :pitches do |t|
      t.string :name
      t.references :pitchtype, foreign_key: true
      t.references :sportground, foreign_key: true

      t.timestamps
    end
  end
end
