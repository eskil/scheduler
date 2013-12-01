class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date :date_at
      t.integer :time_at
      t.integer :spots
      t.integer :activity_id

      t.timestamps
    end
  end
end
