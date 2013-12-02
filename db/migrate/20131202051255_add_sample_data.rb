class AddSampleData < ActiveRecord::Migration
  def change
    surf = Activity.create(:name => "Surfing", :vendor => "Bodhi")
    Schedule.create(:activity => surf,
                    :price => Money.new(10000, "USD"),
                    :date_at => "2013-12-31",
                    :time_at => "12:00",
                    :spots => 6)
    Schedule.create(:activity => surf,
                    :price => Money.new(10000, "USD"),
                    :date_at => "2013-12-24",
                    :time_at => "11:00",
                    :spots => 6)
    Event.create(:activity => surf,
                 :date_at => "2013-12-31",
                 :time_at => "12:00",
                 :spots => 4)

    scuba = Activity.create(:name => "Scuba", :vendor => "Joe Diver")
    Schedule.create(:activity => scuba,
                    :price => Money.new(6500, "USD"),
                    :date_at => "2013-12-24",
                    :time_at => "08:00",
                    :spots => 2)
    Schedule.create(:activity => scuba,
                    :price => Money.new(6500, "USD"),
                    :on_mon => true,
                    :on_wed => true,
                    :on_fri => true,
                    :time_at => "08:00",
                    :spots => 4)
    Schedule.create(:activity => scuba,
                    :price => Money.new(6500, "USD"),
                    :on_mon => true,
                    :on_wed => true,
                    :on_fri => true,
                    :time_at => "18:00",
                    :spots => 2)
    Event.create(:activity => scuba,
                 :date_at => "2013-12-23",
                 :time_at => "08:00",
                 :spots => 2)

    sail = Activity.create(:name => "Sailing", :vendor => "Robert Redford")
    Schedule.create(:activity => sail,
                    :price => Money.new(100000, 'USD'),
                    :date_at => "2013-12-22",
                    :time_at => "10:00",
                    :spots => 1)
  end
end
