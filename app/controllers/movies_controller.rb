# coding: utf-8
class MoviesController < ApplicationController

  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new params[:movie]
    if @movie.save
        flash[:notice] = '添加成功'
        redirect_to movies_path
    else
      flash[:error] = @movie.errors
      render :action => :new
    end
  end

  def edit

  end

  def update

  end

  def show
   @movie = Movie.find params[:id]
   unless @movie
     flash[:error] = "没有相关电影记录"
     redirect_back_or_default movies_path
   end
  end

  def destroy
    movie = Movie.find params[:id]
    if movie
       flash[:notice] = "电影删除成功"
       movie.destroy
    else
      flash[:error] = "未找到要删除的电影"
    end
    redirect_back_or_default movies_path
  end

end
