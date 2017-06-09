class AddApprovalsStatusTable < ActiveRecord::Migration[5.0]
  def change
    create_table :statuses do |t|
      t.string 'status'
      t.string 'comment'
      t.references 'reviewed_by', index: true, foreign_key: { to_table: :users }
      t.references :change, index: true, foreign_key: true, unique: true, null: false
    end
  end
end
