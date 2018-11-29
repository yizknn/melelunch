require 'slack-ruby-bot'
require 'mechanize'

class LunchBot < SlackRubyBot::Bot
  command 'lunch' do |client, data, match|
    query = 'https://retty.me/area/PRE13/PUR1/city/131131500013/'

    agent = Mechanize.new
    page = agent.get(query)

    restaurants = {}
    elements = page.search('a.restaurant__block-link')

    elements.each do |element|
      info = element.inner_text.split("\n")
      restaurants.merge!(info[1].strip => element[:href])
    end

    restaurants = restaurants.to_a.sample(3)

    recommend_comment = ''
    emoji = ":knife_fork_plate:"
    restaurants.each do |restaurant|
      name = restaurant[0].to_s
      link = restaurant[1].to_s

      recommend_comment += emoji + " *" + name + "* " + emoji + " \n" + link + "\n"
    end

    client.say(text: recommend_comment, channel: data.channel)
  end
end

LunchBot.run
