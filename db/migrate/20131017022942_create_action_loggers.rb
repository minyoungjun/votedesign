class CreateActionLoggers < ActiveRecord::Migration
  def change
    create_table :action_loggers do |t|

      t.timestamps
    end
  end
end
