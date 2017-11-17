class TweetsController < ApplicationController
  before_action :set_tweet, only: [:index, :update]

  # GET /tweets
  # GET /tweets.json
  def index
    if (@search_text)# check user is logged in before trying to perform search
      if (current_user)
        @twitter_user_name = @search_text

        if not current_user
          flash[:notice] = 'You must login before performing search'
          redirect_to root_path
        end
        @twitter_user_id = get_twitter_user_id(@twitter_user_name)

        if @twitter_user_id
          session[:current_searched_twitter_user_id] = @twitter_user_id
          @tweets = get_all_tweets(@twitter_user_name)

          if not @tweets or not @tweets.count
            flash[:notice] = "The user #{@twitter_user_name} has no tweets"
          end

          read_tweets = Tweet.get_read_tweets(current_user.id, @twitter_user_id,@tweets.map(&:id)).to_a

          @tweets_hash = @tweets.map { |tweet| tweet.attrs["read"] = false; [tweet.id.to_s, tweet] }.to_h

          mark_read_tweets(@tweets_hash, read_tweets)

          if not @tweets_hash.any? { |id, tweet| not tweet.attrs["read"]}
            flash[:notice] = "The user #{@twitter_user_name} has no unread tweets"
          else
            flash[:notice] = "Tweets from #{@twitter_user_name}"
          end
        else
          flash[:notice] = "The Twitter user #{@twitter_user_name} was not found"
          redirect_to root_path
          if session.key?(:current_searched_twitter_user_id)
            session.delete(:current_searched_twitter_user_id)
          end
          @tweets = false
        end
      else
        redirect_to root_path
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def twitter_client

    if session.key?(:twitter_user_token)
      @twitter_client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_KEY']
        config.consumer_secret     = ENV['TWITTER_SECRET']
        config.access_token        = session[:twitter_user_token]
        config.access_token_secret = session[:twitter_user_secret]
      end
    else
      false
    end

  end

  # helper method to get all tweets in bulks
  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end

  # returns an array of all tweets by the given user
  def get_all_tweets(twitter_user_name)
    collect_with_max_id do |max_id|
      options = {count: 200, include_rts: true}
      options[:max_id] = max_id unless max_id.nil?
      twitter_client.user_timeline(twitter_user_name, options)
    end
  end

  # return the first 20 tweets by the given user
  def get_tweets(twitter_user_name)
    tweets_arr = twitter_client.user_timeline(twitter_user_name, exclude_replies: true, count: 20)
    #tweets_hash = tweets_arr.map { |tweet| [tweet.id, tweet] }.to_h
  end

  # gets the twitter user id according to given user name
  def get_twitter_user_id(user_name)
    begin
      user_result = twitter_client.user(user_name)
      user_id = user_result.id
    rescue Twitter::Error::NotFound => e
      user_id = nil
    end
    user_id
  end

  # gets a hash of tweets and array of read tweets from DB and marks the tweets in the hash as read for relevant tweets
  def mark_read_tweets(all_tweets_hash, read_tweets_arr)
    read_tweets_arr.each do |tweet|
      all_tweets_hash[tweet.tweet_id.to_s].attrs["read"] = true
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @search_text = params[:term]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:term)
    end
end
