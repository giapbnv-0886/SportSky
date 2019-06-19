class AddPhotosToSportgrounds < ActiveRecord::Migration[5.2]
  def change
    add_column :sportgrounds, :photos, :json
  end
end
