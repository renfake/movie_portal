# coding: utf-8
class Company < ActiveRecord::Base
  has_and_belongs_to_many :production_movies, :class_name => 'Movie', :join_table => 'movies_companies', :conditions => {:duty => '出品'}
  has_and_belongs_to_many :shoot_movies,      :class_name => 'Movie', :join_table => 'movies_companies', :conditions => {:duty => '摄制'}

  attr_accessible :name
end
