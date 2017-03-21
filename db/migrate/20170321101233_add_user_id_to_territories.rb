class AddUserIdToTerritories < ActiveRecord::Migration[5.0]
  def change
    add_reference :territories, :user, foreign_key: true
  end
end
