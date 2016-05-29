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

### Telling Your Bot What to Tweet

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

### Getting Twitter Credentials

Next, get your Twitter API credentials ready. Register an app on [Twitter](https://apps.twitter.com/) with read & write permissions. Once you have your API keys, prepare the following pieces of information:

```ruby
credentials = {
  username: '<Your bot\'s Twitter username (without the @ sign)>',
  consumer_key: '<Your consumer key>',
  consumer_secret: '<Your consumer secret>',
  access_token: '<Your access token>',
  access_token_secret: '<Your access token secret>'
}
```

### Making Your Bot Interact with the World

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

### Automating Your Bot's Activities

To make your bot run automatically on a schedule, define a schedule for it like so:

```ruby
bot.schedule do |schedule|
  schedule.every('30m') { bot.tweet }
  schedule.every('3h') { bot.follow_someone }
  schedule.every('1d') { bot.reply_to_someone }
  schedule.cron('15,45 * * * *') { bot.retweet_someone }
end
```

View the [Rufus-Scheduler](https://github.com/jmettraux/rufus-scheduler) documentation to see examples of how to configure the schedule.

For the schedule take effect over time, you need to keep your process open. You can add the following to your Ruby file to keep the process running indefinitely:

```ruby
loop { sleep 1 }
```

### Launching Your Bot

If your Ruby code so far is in a file called `my_bot.rb`, you can launch your bot with the following command in the terminal:

```
ruby my_bot.rb
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/annejohnson/twitter_topic_bot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
