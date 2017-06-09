class AddApprovalsChangesTables < ActiveRecord::Migration[5.0]
  def change
    create_table :changes do |t|
      t.json 'payload'
      t.string 'register_name'
      t.references :user, index: true, foreign_key: true
    end
  end
end
