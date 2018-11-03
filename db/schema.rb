# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_181_103_012_436) do
  create_table 'readings', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.integer 'number', null: false
    t.float 'temperature', limit: 24, default: 0.0, null: false
    t.float 'humidity', limit: 24, default: 0.0, null: false
    t.float 'battery_charge', limit: 24, default: 0.0, null: false
    t.bigint 'thermostats_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[number thermostats_id], name: 'index_readings_on_number_and_thermostats_id', unique: true
    t.index ['thermostats_id'], name: 'index_readings_on_thermostats_id'
  end

  create_table 'sequences', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.bigint 'number', null: false
    t.bigint 'thermostats_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['thermostats_id'], name: 'index_sequences_on_thermostats_id'
  end

  create_table 'stats', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.float 'temperature_total', limit: 53, default: 0.0, null: false
    t.float 'temperature_max', limit: 24, default: 0.0, null: false
    t.float 'temperature_min', limit: 24, default: 0.0, null: false
    t.float 'humidity_total', limit: 53, default: 0.0, null: false
    t.float 'humidity_max', limit: 24, default: 0.0, null: false
    t.float 'humidity_min', limit: 24, default: 0.0, null: false
    t.float 'battery_charge_total', limit: 53, default: 0.0, null: false
    t.float 'battery_charge_max', limit: 24, default: 0.0, null: false
    t.float 'battery_charge_min', limit: 24, default: 0.0, null: false
    t.bigint 'thermostats_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['thermostats_id'], name: 'index_stats_on_thermostats_id', unique: true
  end

  create_table 'thermostats', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.string 'household_token', null: false
    t.geometry 'location'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['household_token'], name: 'index_thermostats_on_household_token', unique: true
  end

  add_foreign_key 'readings', 'thermostats', column: 'thermostats_id'
  add_foreign_key 'sequences', 'thermostats', column: 'thermostats_id'
  add_foreign_key 'stats', 'thermostats', column: 'thermostats_id'
end
