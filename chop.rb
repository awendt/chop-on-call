#!/usr/bin/env ruby

require 'uri'
require 'icalendar'
require 'net/http'

class Chopper

  SUMMARY = '📱 Bereitschaft'

  def initialize(url:, offset_months:)
    @uri = URI(url)
    @offset_months = offset_months.to_i || 1
  end

  def chop!
    calendar = fetch_calendar

    parsed_calendar = Icalendar::Calendar.parse(calendar).first
    fewer_events = reduce_events(parsed_calendar)

    build_new_calendar(change_summary(fewer_events))
  end

  private

  def fetch_calendar
    @cal_file ||= Net::HTTP.get(@uri)
  end

  def reduce_events(calendar)
    requested_month = Date.today >> @offset_months
    calendar.events.reject do |event|
      event.dtstart < beginning_of_month(requested_month) || event.dtstart > end_of_month(requested_month)
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

chopper = Chopper.new(url: ARGV[0], offset_months: ARGV[1])

new_calendar = chopper.chop!

puts new_calendar.to_ical
