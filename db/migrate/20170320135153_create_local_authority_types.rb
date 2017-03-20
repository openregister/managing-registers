class CreateLocalAuthorityTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :local_authority_types do |t|
      t.string :code
      t.string :name
      t.string :start_date
      t.string :end_date
      t.boolean :change_approved, default: false

      t.timestamps
    end

    add_index :local_authority_types, :code, unique: true
  end
end
