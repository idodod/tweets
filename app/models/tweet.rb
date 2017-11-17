class Tweet < ApplicationRecord
  def self.get_read_tweets(user_id, tweet_user_id, tweet_ids)
    read_tweets = where("internal_user_id =? and tweet_user_id=? and tweet_id IN (?) and read =?", user_id, tweet_user_id, tweet_ids, true)
  end

  def self.find_or_create_by(internal_user_id, tweet_id, tweet_user_id, read = true)
    user_tweet = where(internal_user_id: internal_user_id, tweet_id: tweet_id).first_or_create() do |user_tweet|
      user_tweet.tweet_user_id = tweet_user_id
      user_tweet.read = read
    end
    user_tweet
  end
end
