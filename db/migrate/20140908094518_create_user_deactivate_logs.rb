class CreateUserDeactivateLogs < ActiveRecord::Migration
  def change
    create_table :user_deactivate_logs do |t|
      t.integer :id
      t.integer :user_id
      t.text :email_id
      t.text :user_status
      t.timestamp :activate_date
      t.timestamp :deactivate_date
      t.timestamp :inserted_date
      t.timestamp :modified_date

      t.timestamps
    end
  end
end
