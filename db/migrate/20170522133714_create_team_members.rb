class CreateTeamMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :team_members do |t|
      t.string :role

      t.references :team, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      add_index :words, ["id", "language_id"], :unique => true

      t.timestamps
    end

    add_index :team_members, [:team, :user], unique: true
  end
end
