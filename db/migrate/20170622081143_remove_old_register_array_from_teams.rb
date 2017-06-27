class RemoveOldRegisterArrayFromTeams < ActiveRecord::Migration[5.0]
  def change
    remove_column :teams, :registers
  end
end
