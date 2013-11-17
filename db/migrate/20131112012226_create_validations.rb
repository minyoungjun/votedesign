class CreateValidations < ActiveRecord::Migration
  def change
    create_table :validations do |t|
      t.string  :student_number,  :null => false
      t.string  :secure_token,  :null => false
      t.boolean :mail_sent, :default => false
      t.timestamps
    end
  end
end
