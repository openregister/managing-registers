class AddFullNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :full_name, :string
    add_index :users, :full_name, unique: true
  end
end
