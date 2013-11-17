class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.string      :name
      t.string      :email_domain

      t.timestamps
    end
  end
end
