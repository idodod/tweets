class CreateTweets < ActiveRecord::Migration[5.1]
def change
    create_table :tweets do |t|
      t.integer :internal_user_id, :null => false
      t.string :tweet_user_id, :null => false
      t.string :tweet_id, :null => false
      t.boolean :read, :null => false

      t.timestamps
    end

    add_index :tweets, ["internal_user_id", "tweet_id"], :unique => true

  end

end
