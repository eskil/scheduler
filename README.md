Install HAML
============

   * gem install haml


DB
==

Days as Booleans
----------------

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
