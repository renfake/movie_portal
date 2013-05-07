# coding: utf-8
class ScoresController < ApplicationController

  def show
    @movie = Movie.find params[:id]
    @scores = Score.all
    @user_movie_scores = UserMovieScore.find_by_sql ["SELECT * FROM USER_MOVIE_SCORES WHERE USER_ID = ? AND MOVIE_ID  = ?", 1, params[:id]]
  end

  def create
    @movie_id = @id = params[:movie_id]
    if params[:need_update] == 'true'
      @user_id = 1              #need to be replaced by session
      params[:score].each do |key, value|
        @score = Score.find_by_item_name_en(key)
        @ums = UserMovieScore.find_by_sql ["SELECT * FROM USER_MOVIE_SCORES WHERE USER_ID=? AND MOVIE_ID=? AND SCORE_ID=?", @user_id, @movie_id, @score.id]
        @ums[0].update_attribute(:mark, value)
      end
    else
       params[:score].each do |key, value|
         @score = Score.find_by_item_name_en(key)
         @user_movie_score = UserMovieScore.new :user_id => 1, :movie_id => params[:movie_id], :score_id => @score.id, :mark => value
         @user_movie_score.save!
       end
    end
  end

  #查看电影评分结果
  def edit
    @movie = Movie.find params[:id]
    @scores = Score.all
    conn = ActiveRecord::Base::connection
    @ums = conn.execute(%Q{SELECT ROUND(AVG(ums.mark),1) mark, COUNT(ums.user_id) cnt, ums.score_id score_id FROM user_movie_scores ums WHERE ums.movie_id = #{conn.quote(params[:id])} GROUP BY ums.score_id})
  end
end
