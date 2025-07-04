class CreateExecuteRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :execute_records do |t|
      t.string :email
      t.string :action
      t.json :params
      t.json :result

      t.timestamps
    end
  end
end
