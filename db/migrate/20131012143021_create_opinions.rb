class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      
      t.integer   :vote_id,   :null => false
      t.text      :content

      t.timestamps
    end
  end
end
