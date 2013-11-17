class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.integer     :vote_id,       :null => false
      t.string      :admin_name,    :null => false
      t.string      :admin_realname
      t.string      :password,      :null => false
      t.string      :phone_number,  :null => false
      t.boolean     :auto_password_refresh,   :null => false,   :default => false

      t.timestamps
    end
  end
end
