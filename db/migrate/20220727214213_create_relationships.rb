class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.integer :user_id, null: false
      t.integer :greeted_id, null: false

      t.timestamps
    end
    add_foreign_key :relationships, :users, column: :user_id
    add_foreign_key :relationships, :users, column: :greeted_id
  end
end
