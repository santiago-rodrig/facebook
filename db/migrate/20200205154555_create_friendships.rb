class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.references :requester
      t.references :requested
      t.boolean :confirmed

      t.timestamps
    end

    add_index :friendships, [:requester_id, :requested_id], unique: true
  end
end
