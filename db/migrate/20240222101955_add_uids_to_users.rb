class AddUidsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :facebook_uid, :string
    add_column :users, :google_uid, :string
    add_column :users, :linkedin_uid, :string
  end
end
