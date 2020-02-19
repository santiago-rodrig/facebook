class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.references :liker
      t.references :liked_post

      t.timestamps
    end

    add_index :likes, [:liker_id, :liked_post_id], unique: true
  end
end
