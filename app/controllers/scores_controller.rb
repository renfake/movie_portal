class ScoresController < ApplicationController

  def new
    @movie = Movie.find params[:id]
    @scores = Score.all
  end

  def create
    #@user = User.find(1)
    #@movie = Movie.find params[:movie_id]
    params[:score].each do |key, value|
      @score = Score.find_by_item_name_en(key)
      @user_movie_score = UserMovieScore.new :user_id => 1, :movie_id => params[:movie_id], :score_id => @score.id, :mark => value
       #@user_movie_score.save!
      if @user_movie_score.save
        flash[:notice] = '添加成功'
        redirect_to scores_path
      else
        flash[:error] = @score.errors
        render :action => :new
      end
    end
  end
end