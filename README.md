# TwitterTopicBot

[![Gem](https://img.shields.io/gem/v/twitter_topic_bot.svg?style=flat-square)](https://rubygems.org/gems/twitter_topic_bot)
[![Travis](https://img.shields.io/travis/annejohnson/twitter_topic_bot.svg?style=flat-square)](https://travis-ci.org/annejohnson/twitter_topic_bot)

Create a Twitter bot in 5 minutes that tweets and engages with the community on topics you're interested in!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twitter_topic_bot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twitter_topic_bot

## Usage

To let your bot know what to tweet about, you need to make an object that responds to the three methods in the code sample below. The topic below is art, but your topic can be about anything.

```ruby
class ArtContentPreparer
  def topic_string
    ['#painting', '#watercolor'].sample
  end

  def prepare_tweet
    %q{If you hear a voice within you say 'you cannot paint,' then by all means paint, and that voice will be silenced. -Vincent Van Gogh}
  end

  def prepare_reply(tweet_to_reply_to, user_to_reply_to)
    "@#{user_to_reply_to}, thank you for tweeting about art!"
  end
end

content_preparer = ArtContentPreparer.new
```

Next, get your Twitter API credentials ready. Register an app on [Twitter](https://apps.twitter.com/) with read & write permissions. Once you have your API keys, prepare the following pieces of information:

```ruby
credentials = {
  username: '<Your bot\'s username (without the @ sign)>',
  consumer_key: '<Your consumer key>',
  consumer_secret: '<Your consumer secret>',
  access_token: '<Your access token>',
  access_token_secret: '<Your access token secret>'
}
```

Next, instantiate a `TwitterTopicBot`, and make it do things!

```ruby
bot = TwitterTopicBot.new(content_preparer, credentials)

bot.tweet
bot.retweet_someone
bot.follow_someone
bot.retweet_mentions
bot.reply_to_someone
bot.follow_followers
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/annejohnson/twitter_topic_bot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
