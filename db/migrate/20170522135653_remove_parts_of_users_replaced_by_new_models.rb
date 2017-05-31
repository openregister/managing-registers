class RemovePartsOfUsersReplacedByNewModels < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :registers
    remove_column :users, :role
  end
end
