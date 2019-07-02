class AddMinrentalToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :minrental, :integer, default: 1
  end
end
