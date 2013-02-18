class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string        :name,      :null => false
      t.date          :birthday
      t.text          :bio
      t.timestamps
    end
  end
end
