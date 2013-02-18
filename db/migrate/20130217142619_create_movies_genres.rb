class CreateMoviesGenres < ActiveRecord::Migration
  def change
      create_table :movies_genres, :id => false do |t|
        t.integer :movie_id, :null => false
        t.integer :genre_id, :null => false
      end
    end
end
