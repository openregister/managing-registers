class AlterIndexUsersFullNameUniqueConstraint < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :full_name
    add_index :users, :full_name
  end
end
