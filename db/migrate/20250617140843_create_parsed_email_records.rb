class CreateParsedEmailRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :parsed_email_records do |t|
      t.integer :inbound_email_id
      t.string :email
      t.string :type
      t.jsonb :data
      t.string :sent_at

      t.timestamps

      t.index :email
      t.index :type
    end
  end
end
