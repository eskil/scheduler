Examples
========

Create an activity;

  curl -include -H "Content-type: application/json" --header "Accept: application/json" -X POST -d '{"name": "scuba", "vendor": "joe diver"}' http://localhost:3003/activities
  =>
  201, {"id":1}


Create a scheduled dated event;

  curl -include -H "Content-type: application/json" --header "Accept: application/json" -X POST -d '{"activity_id": "1", "date": "2013-12-24", "time": "17:00", "spots": 8, "price_cents": 10000, "price_currency": "USD"}' http://localhost:3003/schedules
  =>
  {}

Create a scheduled recurring events

  curl -include -H "Content-type: application/json" --header "Accept: application/json" -X POST -d '{"activity_id": 1, "recurring": "mon, tue, fri", "time": "17:00", "spots": 8, "price_cents": 10000, "price_currency": "USD"}' http://localhost:3003/schedules
  =>
  {}

Query a date;

  curl -include -H "Content-type: application/json" --header "Accept: application/json" -X GET -d '{"date": "2013-12-24"}' http://localhost:3003/schedules/query


Query a date range;

  curl -include -H "Content-type: application/json" --header "Accept: application/json" -X GET -d '{"from_date": "2013-12-20", "to_date": "2013-12-26"}' http://localhost:3003/schedules/query

Create a reservation;

  curl -include -H "Content-type: application/json" --header "Accept: application/json" -X POST -d '{"activity_id": 1, "date": "2013-12-24", "time": "17:00", "spots": 4}' http://localhost:3003/events

  201 = created, ok
  404 = activity not found
  403 = forbidden, date/time not available
  409 = conflict, activity/date/time is ok, but not enough spots, see 'spots'


Delete scheduled activity

  curl -include -H "Content-type: application/json" --header "Accept: application/json" -X DELETE http://localhost:3003/schedules/1

DB
==

Prices
------

An activity's price is associated with the scheduled event, this
allows different dates/times to have different prices. The price
stored as cents/currency and uses the Money gem.

Scheduled Time
--------------

The scheduled time is stored as seconds since midnight on the
date/day. This is timezone agnostic since an event will always happen
on the local time of event and therefore not relevant to the timezone
of the client.

Days as Booleans For Recurring
------------------------------

Reasons to not use a lookup table;

   * The key set (weekdays) is fixed, it does not change.

   * Changing an activity's occurrences is now done on this lookup
     table, making sharding harder (the activities table can be
     sharded and multiple tables easily queried to obtain all
     activities for a certain set of weekdays).

   * It's more likely that the set of activities will first be reduced
     by a geographic and category, and the actual set of weekdays is
     the last reduction.

Reasons to not use a bit set;

   * We cannot guarantee that a storage system can index efficiently
     when doing (weekdays & N) queries.

   * Queries ala "WHERE weekdays & 0x4" are annoying to read in the
     long run.

Reasons to not use a concat string ala (mon,wed,sat);

   * We can probably guarantee that no storage system can efficiently
     index this when querying...

Reasons for separate bool columns;

   * Easier to read/explain.

   * Queries are simple and most storage systems can efficiently index
     bool columns.

   * Even if the storage system does not pack them, it's only 7 bytes
     per entry, and the set of weekdays is fixed and will not grow
     (although you could add entries for weekdays/weekend-days).
