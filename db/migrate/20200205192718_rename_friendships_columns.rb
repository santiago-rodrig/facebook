class RenameFriendshipsColumns < ActiveRecord::Migration[5.1]
  def change
    change_table :friendships do |t|
      t.rename :requester_id, :user_id
      t.rename :requested_id, :friend_id
    end

    change_column :friendships, :confirmed, :boolean, default: false
  end
end
