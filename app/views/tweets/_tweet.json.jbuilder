json.extract! tweet, :id, :internal_user_id, :tweet_user_id, :tweet_id, :read, :created_at, :updated_at
json.url tweet_url(tweet, format: :json)
