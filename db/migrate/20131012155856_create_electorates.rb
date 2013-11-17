class CreateElectorates < ActiveRecord::Migration
  def change
    create_table :electorates do |t|

      t.integer     :vote_id,     :null => false
      t.string      :realname,        :null => false
      t.string      :student_number,  :null => false
      t.string      :division
      t.string      :major
      t.boolean     :absent,      :default => false
      t.boolean     :voted,       :default => false

      t.timestamps
    end
  end
end
