class CreateLocalAuthorityEngs < ActiveRecord::Migration[5.0]
  def change
    create_table :local_authority_engs do |t|
      t.string :name
      t.string :official_name
      t.string :start_date
      t.string :end_date
      t.string :local_authority_type
      t.string :code
      t.boolean :change_approved, default: false

      t.timestamps
    end

    add_index :local_authority_engs, :code, unique: true
  end
end
