class AddSessionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :session_token, :string
    change_column :users, :session_token, :string, null: false 
    add_index :users, :session_token
  end

end
