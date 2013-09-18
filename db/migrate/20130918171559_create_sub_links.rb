class CreateSubLinks < ActiveRecord::Migration
  def change
    create_table :sub_links do |t|
      t.integer :link_id, null: false
      t.integer :sub_id, null: false

      t.timestamps
    end
  end
end
