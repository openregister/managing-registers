class AddUserIdToCountries < ActiveRecord::Migration[5.0]
  def change
    add_reference :countries, :user, foreign_key: true
  end
end
