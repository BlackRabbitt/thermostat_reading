class AddStatFieldsToThermostat < ActiveRecord::Migration[6.0]
  def change
    add_column :thermostats, :readings_count, :integer

    add_column :thermostats, :temperature_sum, :float
    add_column :thermostats, :temperature_max, :float
    add_column :thermostats, :temperature_min, :float

    add_column :thermostats, :humidity_sum, :float
    add_column :thermostats, :humidity_max, :float
    add_column :thermostats, :humidity_min, :float

    add_column :thermostats, :battery_charge_sum, :float
    add_column :thermostats, :battery_charge_max, :float
    add_column :thermostats, :battery_charge_min, :float
  end
end
