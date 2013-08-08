class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.text :description
      t.integer :user_id
      t.boolean :done
      t.timestamp :deadline

      t.timestamps
    end
  end
end
