class MeetupEvent
  attr_accessor :name, :description, :time, :attendees, :venue, :address, :url

  def initialize(attrs)
    self.name = attrs[:name]
    self.description = attrs[:description]
    self.time = Time.at(attrs[:time] / 1000).to_datetime
    self.attendees = attrs[:attendees]
    self.address = attrs[:address]
    self.venue = attrs[:venue]
    self.url = attrs[:url]
  end

  class << self
    def all
      json = HTTParty.get("https://api.meetup.com/2/events?&sign=true&photo-host=public&group_id=15138792,12922902,5356052&page=20&key=#{ENV['MEETUP_API_KEY']}").body
      raw_events = JSON.parse(json)['results']
      events = []
      raw_events.each do |event|
        events << MeetupEvent.new(
          name: event['name'],
          description: event['description'],
          time: event['time'],
          attendees: event['yes_rsvp_count'],
          address: event['venue']['address_1'],
          venue: event['venue']['name'],
          url: event['event_url'],
        )
      end
      events
    end
  end
end
