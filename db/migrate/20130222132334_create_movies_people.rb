class CreateMoviesPeople < ActiveRecord::Migration
  def change
     create_table :movies_people, :id => false do |t|
       t.integer       :movie_id,      :null => false
       t.integer       :person_id,     :null => false
       t.string        :profession,    :null => false
       t.string        :profession_content
     end
   end
end
