class CreateRegisterTableToMaintainReferentialIntegrity < ActiveRecord::Migration[5.0]
  def change
    create_table :registers do |r|
      r.string :key, null: false
      r.references :team, index: true, foreign_key: true
      r.timestamps
    end
    add_index :registers, :key, unique: true
  end
end
