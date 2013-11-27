class AddWeekdaysToActivity < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.boolean :on_mon
      t.boolean :on_tue
      t.boolean :on_wed
      t.boolean :on_thu
      t.boolean :on_fri
      t.boolean :on_sat
      t.boolean :on_sun
    end
  end
end
