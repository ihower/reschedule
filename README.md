# Reschedule

a Ruby library using Redis for scheduling calculation. 

* It stores available time in Redis Set by minutes. So it can respond available? in O(durations) time complexity.
* It can answer marked time for specific date in O(1440) time complexity.
* It caches the data for 7 days(default), otherwise it will raise exception which mean you need populate.
* Reschedule::Day is the basic element for calculation, and we can intersect two Reschedule::Day.

## Requirement

* Redis

### Run spec

  bundle exec rspec spec

## License

Copyright © 2011 Wen-Tien Chang
Licensed under the MIT: http://www.opensource.org/licenses/mit