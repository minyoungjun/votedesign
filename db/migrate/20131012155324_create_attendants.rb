class CreateAttendants < ActiveRecord::Migration
  def change
    create_table :attendants do |t|

      t.integer     :vote_id,       :null => false
      t.string      :email_address, :null => false
      t.string      :secure_token,  :null => false
      t.string      :password,      :null => false

      t.timestamps
    end
  end
end
