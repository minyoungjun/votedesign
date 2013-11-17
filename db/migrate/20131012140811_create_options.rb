class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      
      t.integer   :vote_id,   :null => false

      t.string    :name
      t.string    :content
      t.string    :person_first
      t.string    :person_second 
      t.text      :self_content
      t.text      :public_content

      #t.integer   :score,   :default => 0

      t.timestamps
    end
  end
end
