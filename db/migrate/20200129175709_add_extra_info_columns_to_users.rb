class AddExtraInfoColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.column :phone, :string
      t.column :birthday, :date
      t.column :gender, :string
      t.column :image_url, :string
      t.column :first_name, :string
      t.column :last_name, :string
    end
  end
end
