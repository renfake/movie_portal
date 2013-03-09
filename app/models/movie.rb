# coding: utf-8
class Movie < ActiveRecord::Base
  belongs_to :category
  belongs_to :age
  has_and_belongs_to_many :genres

  has_and_belongs_to_many   :production_companies, :class_name => 'Company', :join_table => 'movies_companies', :conditions => {:duty => '出品'}
  has_and_belongs_to_many   :shoot_companies,      :class_name => 'Company', :join_table => 'movies_companies', :conditions => {:duty => '摄制'}

  has_many :movies_people

  has_many   :directors,            :class_name => 'Person', :through => 'movies_people',     :conditions => {:duty => '导演'}
  has_many   :actors,               :class_name => 'Person', :through => 'movies_people',     :conditions => {:duty => '演员'}

  attr_accessible :name, :country, :runtime
end
