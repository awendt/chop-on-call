# Chop off a month from an iCal file

## Purpose

PagerDuty schedules are perpetual calendars but our team assign shifts every month.
We create overrides for each month so the schedule is accurate one month in advance.

When I export my schedule in iCal format, I'm interested only in the next month so
I can import it into my private calendar.

That's what this script is for: It takes my schedule and chops off the next month
(or current if I'm going it on the first of the month).

Essentially, it takes an iCal URL as input, filters all events in the next (or current)
month and generates a new iCal file.

For information how to get the iCal URL from PagerDuty, see
[Schedules in Third-Party Apps](https://support.pagerduty.com/docs/schedules-in-apps)

## Usage

As a one-time setup, install the dependencies:

```
$ bundle
```

Then:

```
$ ruby $PAGERDUTY_SCHEDULE_URL 1 # keep the next month
$ ruby $PAGERDUTY_SCHEDULE_URL 0 # keep the current month
```
