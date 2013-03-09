class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string    :name,        :null => false
      t.integer   :movie_id
      t.text      :biography
      t.timestamps
    end
  end
end
