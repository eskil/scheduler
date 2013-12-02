API
===

All API calls return 404 if activity/schedule ID is not found.

Create an activity
-------------------

  POST /activites
  name: name of activity
  vendor: name of vendor

  Returns 201 on success:
  id: created id

example

  curl -include --header "Content-type: application/json" --header "Accept: application/json" -X POST -d '{"name": "scuba", "vendor": "joe diver"}' http://localhost:3003/activities
  =>
  201, {"id":1}


Schedule an activity
--------------------

  POST /activities/:activity_id/schedule
  date: ISO8601 date
  time: time of event as HH:MM
  spots: number of available spots
  price_cents: purchase price in 100th of currency
  price_currency: purchase price currency

  Returns 201 on success:
  id: created schedule id

example

  curl -include --header "Content-type: application/json" --header "Accept: application/json" -X POST -d '{"date": "2013-12-24", "time": "17:00", "spots": 8, "price_cents": 10000, "price_currency": "USD"}' http://localhost:3003/activities/1/schedule
  =>
  201, {"id":1}

Schedule a recurring activity
-----------------------------

  POST /activities/:activity_id/schedule
  recurring: space seperated list of weekdays (sun mon tue wed thu fri sat) on which activity recurs.
  time: time of event as HH:MM
  spots: number of available spots
  price_cents: purchase price in 100th of currency
  price_currency: purchase price currency

  Returns 201 on success:
  id: created schedule id

example

  curl -include --header "Content-type: application/json" --header "Accept: application/json" -X POST -d '{"recurring": "mon fri", "time": "17:00", "spots": 8, "price_cents": 10000, "price_currency": "USD"}' http://localhost:3003/activities/1/schedule
  =>
  201, {"id":2}

Delete a Schedule
-----------------

  DELETE /activities/:activity_id/schedule/:schedule_id

  Returns 200 on success

example

  curl -include --header "Content-type: application/json" --header "Accept: application/json" -X DELETE http://localhost:3003/activities/1/schedule/1
  =>
  204 on success

Query a Date
------------

  GET /schedules/query
  date: ISO8601 date to query
  activity_id: (optional) only query a specific activity

  Returns 200 on success
  activities: dictionary of activities, mapping from activity id to activity
    name: activity name
    vendor: activity vendor
  availabilities: dictionary of availabilities, mapping from date to a list of availabilities
    activity_id: activity id matching the activities returned in 'activities'
    time_at: time of availability as HH:MM
    spots: number of spots available

example

  curl -include --header "Content-type: application/json" --header "Accept: application/json" -X GET -d '{"date": "2013-12-24"}' http://localhost:3003/schedules/query
  =>
  200, {"activities":{"2":{"id":2,"name":"surf","vendor":"bodhi"}},"availabilities":{"2013-12-20":[{"activity_id":2,"time_at":61200,"spots":8}],"2013-12-24":[{"activity_id":2,"time_at":61200,"spots":8}],"2013-12-31":[{"activity_id":2,"time_at":61200,"spots":8}]}}

Query a Date Range
------------------

  GET /schedules/query
  from_date: ISO8601 date to query from
  to_date: ISO8601 date to query to
  activity_id: (optional) only query a specific activity

  Returns 200 on success
  (same data as querying a date)

example

  curl -include --header "Content-type: application/json" --header "Accept: application/json" -X GET -d '{"from_date": "2013-12-20", "to_date": "2013-12-26"}' http://localhost:3003/schedules/query
  =>
  200, json...

Book an Activity
----------------

  POST /activities/:activity_id/book
  date: ISO8601 to book on
  time: time to book at as HH:MM
  spots: number of spots to book

  Returns 201 on success
  id: booking id

  Returns 403 if date/time is not availabe
  reason: "date/time"

  Returns 403 if not enough spots
  reason: "spots"
  spots: number of spots available

example

  curl -include --header "Content-type: application/json" --header "Accept: application/json" -X POST -d '{"date": "2013-12-24", "time": "17:00", "spots": 4}' http://localhost:3003/activities/1/book
  =>
  {"id": 1}


Database
========

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

A activity scheduled by date takes precedence over events scheduled by
recurrence.

Bookings
--------

Booking an activity generates an event. An event is not tied to a
schedule as this isn't relevant at this stage.

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


Test Set
========

curl -i -H "Content-type: application/json" -H "Accept: application/json" -X POST -d '{"name": "scuba", "vendor": "joe diver"}' http://localhost:3003/activities

curl -i -H "Content-type: application/json" -H "Accept: application/json" -X POST -d '{"date": "2013-12-24", "time": "08:00", "spots": 2, "price_cents": 6500, "price_currency": "USD"}' http://localhost:3003/activities/1/schedule
curl -include -H "Content-type: application/json" -H "Accept: application/json" -X POST -d '{"recurring": "mon fri", "time": "08:00", "spots": 2, "price_cents": 6500, "price_currency": "USD"}' http://localhost:3003/activities/1/schedule

curl -i -H "Content-type: application/json" -H "Accept: application/json" -X POST -d '{"date": "2013-12-24", "time": "08:00", "spots": 2}' http://localhost:3003/activities/1/book
curl -i -H "Content-type: application/json" -H "Accept: application/json" -X POST -d '{"date": "2013-12-23", "time": "08:00", "spots": 1}' http://localhost:3003/activities/1/book

curl -i -H "Content-type: application/json" -H "Accept: application/json" -X POST -d '{"name": "surf", "vendor": "bodhi"}' http://localhost:3003/activities

curl -i -H "Content-type: application/json" -H "Accept: application/json" -X POST -d '{"date": "2013-12-23", "time": "17:00", "spots": 8, "price_cents": 10000, "price_currency": "USD"}' http://localhost:3003/activities/2/schedule
curl -i -H "Content-type: application/json" -H "Accept: application/json" -X POST -d '{"recurring": "tue fri", "time": "17:00", "spots": 8, "price_cents": 10000, "price_currency": "USD"}' http://localhost:3003/activities/2/schedule

curl -i -H "Content-type: application/json" -H "Accept: application/json" -X POST -d '{"date": "2013-12-23", "time": "17:00", "spots": 4}' http://localhost:3003/activities/2/book
curl -i -H "Content-type: application/json" -H "Accept: application/json" -X POST -d '{"date": "2013-12-27", "time": "17:00", "spots": 4}' http://localhost:3003/activities/2/book
