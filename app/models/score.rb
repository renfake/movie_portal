# coding: utf-8
class Score < ActiveRecord::Base
  ##自引用的连接配置
  belongs_to :parent,   :class_name => "Score",    :foreign_key => "parent_id"
  has_many   :children, :class_name => "Score",    :foreign_key => "parent_id",   :dependent => :destroy
  attr_accessible :item_name, :item_name_en, :min_score, :max_score, :step, :description
end
