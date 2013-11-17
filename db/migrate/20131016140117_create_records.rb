class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string    :action_type
      t.string    :actor
      t.string    :location
      t.integer   :score,   :default => 1

      t.timestamps

    end
  end
end
