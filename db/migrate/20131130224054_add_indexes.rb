class AddIndexes < ActiveRecord::Migration
  def change
    add_index :schedules, :activity_id
    add_index :schedules, :on_sun
    add_index :schedules, :on_mon
    add_index :schedules, :on_tue
    add_index :schedules, :on_wed
    add_index :schedules, :on_thu
    add_index :schedules, :on_fri
    add_index :schedules, :on_sat
    add_index :schedules, :date_at

    add_index :events, :activity_id
    add_index :events, :date_at
    add_index :events, :time_at
  end
end
