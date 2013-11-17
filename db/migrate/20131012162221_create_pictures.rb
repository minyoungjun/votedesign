class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|

      t.integer   :option_id
      t.string    :saved_name

      t.timestamps
    end
  end
end
