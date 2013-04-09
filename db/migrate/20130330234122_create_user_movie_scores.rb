# coding: utf-8
class CreateUserMovieScores < ActiveRecord::Migration
  def change
    create_table :user_movie_scores do |t|
      t.integer  :user_id
      t.integer  :movie_id
      t.integer  :score_id
      #具体分数
      t.decimal  :mark,        :default => 0
    end
  end
end
