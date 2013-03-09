# coding: utf-8
class Movie < ActiveRecord::Base
  # 片种
  belongs_to :category
  # 所属年代
  belongs_to :age
  # 规格
  belongs_to :format
  # 色别
  belongs_to :color
  # 类型
  has_and_belongs_to_many :genres
  # 敏感问题
  has_and_belongs_to_many :issues
  # 出品公司
  has_and_belongs_to_many   :production_companies, :class_name => 'Company', :join_table => 'movies_companies', :conditions => {:duty => '出品'}
  # 摄制公司
  has_and_belongs_to_many   :shoot_companies,      :class_name => 'Company', :join_table => 'movies_companies', :conditions => {:duty => '摄制'}

  # 人员
  has_many :movies_people

  # 导演
  has_many   :directors,            :class_name => 'Person', :through => 'movies_people',     :conditions => { :profession => '导演'}
  # 主要演员
  has_many   :stars,                 :class_name => 'Person', :through => 'movies_people',    :conditions => { :profession => '主要演员'}
  # 演员
  has_many   :actors,               :class_name => 'Person', :through => 'movies_people',
             :conditions => ["profession = ? or profession =?", '演员', '主要演员']

  attr_accessible :name, :country, :production_date, :category_id, :auditing_file, :age_id, :age_note, :runtime,
                  :color_id, :format_id, :picture_id, :plot_summary, :director_statement, :note, :created_by, :updated_by
end
