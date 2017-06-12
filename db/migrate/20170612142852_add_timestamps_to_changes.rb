class AddTimestampsToChanges < ActiveRecord::Migration[5.0]
  def change
    add_column :changes, :created_at, :datetime
    add_column :changes, :updated_at, :datetime
  end
end
