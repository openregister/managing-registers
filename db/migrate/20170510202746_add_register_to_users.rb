class AddRegisterToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :registers, :string, array: true, default: []
  end
end
