class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :link_id, null: false
      t.integer :user_id, null: false
      t.integer :parent_id
      t.text :body, null: false

      t.timestamps
    end

    add_index :comments, :link_id
    add_index :comments, :user_id
    add_index :comments, :parent_id
  end
end
