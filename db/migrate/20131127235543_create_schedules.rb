class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :activity_id

      t.boolean :on_sun, :default => false
      t.boolean :on_mon, :default => false
      t.boolean :on_tue, :default => false
      t.boolean :on_wed, :default => false
      t.boolean :on_thu, :default => false
      t.boolean :on_fri, :default => false
      t.boolean :on_sat, :default => false

      t.date :date_at
      t.integer :time_at

      t.integer :price_cents, :default => 0
      t.string :price_currency, :default => 'USD'
      t.integer :spots

      t.timestamps
    end
  end
end
