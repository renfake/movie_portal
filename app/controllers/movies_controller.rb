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
end
