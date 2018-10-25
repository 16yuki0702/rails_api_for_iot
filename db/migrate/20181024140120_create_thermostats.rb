class CreateThermostats < ActiveRecord::Migration[5.1]
  def change
    create_table :thermostats do |t|
      t.string :household_token
      t.geometry :location

      t.timestamps
    end
    add_index :thermostats, :household_token, unique: true
  end
end
