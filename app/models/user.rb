class User < ApplicationRecord
  def self.find_or_create_from_auth_hash(auth_hash)
    user = where(twitter_user_id: auth_hash.uid).first_or_create() do |user|
      user.name = auth_hash.info.nickname
    end
    user
  end
end