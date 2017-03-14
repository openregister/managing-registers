class CreateTerritories < ActiveRecord::Migration[5.0]
  def change
    create_table :territories do |t|
      t.string :name
      t.string :official_name
      t.string :start_date
      t.string :end_date
      t.string :code
      t.boolean :change_approved, default: false

      t.timestamps
    end

    add_index :territories, :code, unique: true
  end
end
