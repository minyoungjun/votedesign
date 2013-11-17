class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|

      t.string      :realname
      t.string      :student_number
      t.string      :division
      t.string      :major
      t.string      :phone
      
      t.timestamps
    end
  end
end
