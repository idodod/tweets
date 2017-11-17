class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :twitter_user_id, :null => false
      t.string :name, :null => false

      t.timestamps
    end

    add_index :users, ["twitter_user_id"], :unique => true
    add_index :users, ["name"], :unique => true
  end
end
