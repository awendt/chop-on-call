#!/usr/bin/env ruby

require 'uri'
require 'icalendar'
require 'net/http'

class Chopper

  SUMMARY = '📱 Bereitschaft'

  def initialize(url)
    @uri = URI(url)
  end

  def chop!
    calendar = fetch_calendar

    parsed_calendar = Icalendar::Calendar.parse(calendar)
    fewer_events = reduce_events(parsed_calendar.first)

    build_new_calendar(change_summary(fewer_events))
  end

  private

  def fetch_calendar
    @cal_file ||= Net::HTTP.get(@uri)
  end

  def reduce_events(calendar)
    calendar.events.reject do |event|
      event.dtstart < beginning_of_month(Date.today >> 1) || event.dtstart > end_of_month(Date.today >> 1)
    end
  end

  def change_summary(events)
    events.map do |event|
      event.summary = SUMMARY
      event
    end
  end

  def build_new_calendar(events)
    new_calendar = Icalendar::Calendar.new
    events.each do |event|
      new_calendar.add_event(event)
    end
    new_calendar
  end

  def beginning_of_month(date)
    Date.new(date.year, date.month, 1)
  end

  def end_of_month(date)
    beginning_of_month(date.next_month) - 1
  end

end

chopper = Chopper.new(ARGV[0])

new_calendar = chopper.chop!

puts new_calendar.to_ical
