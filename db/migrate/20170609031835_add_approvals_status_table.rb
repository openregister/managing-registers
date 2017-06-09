class AddApprovalsStatusTable < ActiveRecord::Migration[5.0]
  def change
    create_table :status do |t|
      t.string 'status'
      t.string 'comment'
      t.references 'reviewed_by', index: true, foreign_key: { to_table: :users }
      t.references :change, index: true, foreign_key: true
    end
  end
end
