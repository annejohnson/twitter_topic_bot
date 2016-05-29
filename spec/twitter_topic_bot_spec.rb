require 'spec_helper'

describe TwitterTopicBot do

  let(:twitter_api_credentials) do
    {
      consumer_key: 'your_consumer_key',
      consumer_secret: 'your_consumer_secret',
      access_token: 'your_access_token',
      access_token_secret: 'your_access_token_secret'
    }
  end

  let(:content_preparer) do
    Struct.new('ContentPreparer') do
      def prepare_tweet
        'Hello, Twitterverse!'
      end

      def prepare_reply(tweet_to_reply_to, user_to_reply_to)
        'Thanks for tweeting!'
      end

      def topic_string
        '#currentEvents'
      end
    end.new
  end

  subject { described_class.new(content_preparer, twitter_api_credentials) }
  let(:api_client) { instance_double(Twitter::REST::Client) }
  let(:topic_tweet_user) { instance_double(Twitter::User) }
  let(:mention_tweet_user) { instance_double(Twitter::User) }
  let(:topic_tweet) { instance_double(Twitter::Tweet) }
  let(:mention_tweet) { instance_double(Twitter::Tweet) }

  before :each do
    expect(Twitter::REST::Client).to receive(:new).
      and_return(api_client)
    # mock user
    [mention_tweet_user, topic_tweet_user].each do |user|
      allow(user).to receive(:id).
        and_return((1..500).to_a.sample)
    end
    # mock tweet
    [mention_tweet, topic_tweet].each do |tweet|
      allow(tweet).to receive(:id).
        and_return((1..500).to_a.sample)
      allow(tweet).to receive(:lang).
        and_return('en')
      allow(tweet).to receive(:favorite_count).
        and_return((0..10).to_a.sample)
    end
    allow(topic_tweet).to receive(:text).
      and_return("Can you believe yesterday's headline? #currentEvents")
    allow(topic_tweet).to receive(:user).
      and_return(topic_tweet_user)
    allow(mention_tweet).to receive(:text).
      and_return('Hey, @twitter_topic_bot, thanks for following!')
    allow(mention_tweet).to receive(:user).
      and_return(mention_tweet_user)
  end

  describe '#tweet' do
    it 'tweets about the topic' do
      expect(api_client).to receive(:update).
        with(content_preparer.prepare_tweet, any_args)
      subject.tweet
    end
  end

  describe '#retweet_someone' do
    before :each do
      expect(api_client).to receive(:search).
        with(content_preparer.topic_string, any_args).
        and_return([topic_tweet])
    end

    it 'retweets someone who has tweeted about the topic' do
      expect(api_client).to receive(:retweet).
        with(kind_of(Numeric))
      subject.retweet_someone
    end
  end

  describe '#follow_someone' do
    before :each do
      expect(api_client).to receive(:search).
        with(content_preparer.topic_string, any_args).
        and_return([topic_tweet])
    end

    it 'follows someone who has tweeted about the topic' do
      expect(api_client).to receive(:follow).
        with(kind_of(Numeric))
      subject.follow_someone
    end
  end

  describe '#retweet_mentions' do
    before :each do
      expect(api_client).to receive(:mentions_timeline).
        and_return([mention_tweet])
    end

    it 'retweets mentions' do
      expect(api_client).to receive(:retweet).
        with(kind_of(Numeric))
      subject.retweet_mentions
    end
  end

  describe '#reply_to_someone' do
    before :each do
      expect(api_client).to receive(:search).
        with(content_preparer.topic_string, any_args).
        and_return([topic_tweet])
    end

    it 'replies to a tweet about the topic' do
      expect(api_client).to receive(:update).
        with(
          content_preparer.prepare_reply('hi', 'username'),
          hash_including(in_reply_to_status_id: kind_of(Numeric))
        )
      subject.reply_to_someone
    end
  end

  describe '#follow_followers' do
    it 'follows its followers' do
      expect(api_client).to receive(:follow).
        with(kind_of(Numeric))
      subject.follow_followers
    end
  end
end
