class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :user_id, null: false
      t.integer :dog_id, null: false

      t.timestamps
    end
    add_index :likes, :user_id
    add_index :likes, :dog_id
    add_index :likes, [:user_id, :dog_id], unique: true
  end
end
