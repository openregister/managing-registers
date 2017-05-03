class DropRegisterSpecificTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :local_authority_engs
    drop_table :local_authority_types
    drop_table :territories
    drop_table :countries
  end
end
