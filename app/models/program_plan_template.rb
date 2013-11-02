# coding: utf-8
class ProgramPlanTemplate < ActiveRecord::Base
  attr_accessible :name, :desc, :status, :time_bucket_num, :day_column_num, :day_row_num, :period, :channel_id, :created_by, :updated_by

  belongs_to :creater, :class_name => 'User', :foreign_key => 'created_by'
  belongs_to :updater, :class_name => 'User', :foreign_key => 'updated_by'

  belongs_to :channel

  has_many :items, :class_name => 'ProgramPlanTemplateItem', :foreign_key =>  'program_plan_template_id'
  has_many :time_buckets, :class_name =>  'ProgramPlanTemplateTimeBucket', :foreign_key =>  'program_plan_template_id'

  validates_presence_of :name
  validates_numericality_of :time_bucket_num, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 24
  validates_inclusion_of :period, :in => %w( WEEK MONTH ), :message => '编排周期应是周(WEEK)或月(MONTH)'
  validates_inclusion_of :status, :in => %w( ACTIVE  DELETED INACTIVE )



  def init_items_hash
    unless @items_hash
      @items_hash = Hash.new

      day_row_num.times do |row|
        @items_hash[row]=Hash.new
        day_column_num.times do |column|
          @items_hash[row][column] = Hash.new
          time_bucket_num.times do |time_bucket|
            @items_hash[row][column][time_bucket] = nil
          end
        end
      end

      items.each do |item|
        @items_hash[item.day_row][item.day_column][item.time_bucket] = item
      end
    end
  end

  def items_hash
    init_items_hash
    @items_hash
  end

end
