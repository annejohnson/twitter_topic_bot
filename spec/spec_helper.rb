$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
Dir['./spec/support/**/*.rb'].sort.each { |f| require f}

require 'twitter_topic_bot'

def random_string
  (0...30).map { ('a'..'z').to_a[rand(26)] }.join
end

def random_integer
  (1..500).to_a.sample
end
