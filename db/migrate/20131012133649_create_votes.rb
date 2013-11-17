class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|

      t.string      :title
      t.string      :content
      t.string      :detail
      t.integer     :admin_id,     :null => false
      t.string      :picture_name
=begin
      t.boolean     :realtime_result_flag,    :null => false
      t.boolean     :pros_cons_flag,          :null => false
      t.boolean     :commentable_flag,        :null => false
      t.boolean     :multiple_choice_flag,    :null => false
      t.boolean     :additional_opinion_flag, :null => false
=end

      t.datetime    :start_time,  :null => false
      t.datetime    :end_time,    :null => false
      t.integer    :open_time, :default => 9
      t.integer    :close_time, :default => 18

      t.timestamps
    end
  end
end
