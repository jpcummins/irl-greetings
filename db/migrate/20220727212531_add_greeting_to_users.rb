class AddGreetingToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :greeting, :string
  end
end
