class AddUserIdToLocalAuthorityTypes < ActiveRecord::Migration[5.0]
  def change
    add_reference :local_authority_types, :user, foreign_key: true
  end
end
