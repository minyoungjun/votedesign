class CreateCounts < ActiveRecord::Migration
  def change
    create_table :counts do |t|
      t.integer :vote_id,     :null => false
	    t.integer	:option_id,   :null => false
    end
  end
end
