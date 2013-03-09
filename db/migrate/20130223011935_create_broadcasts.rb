# coding: utf-8
class CreateBroadcasts < ActiveRecord::Migration
  def change
    create_table :broadcasts do |t|
      ## 周次
      t.integer       :week, :null => false
      ## 日期
      t.date          :date, :null => false
      ## 开始时间
      t.time          :start_time, :null => false
      ## 电影
      t.integer       :movie_id,   :null => false
      ## 收视率
      t.decimal       :audience_rating, :null => false, :precision => 5, :scale => 2
      ## 收拾份额
      t.decimal       :audience_share,  :null => false, :precision => 5, :scale => 2
      ## 观众人数
      t.integer       :audience_number,  :null => false
      ## 时段
      t.integer       :time_bucket,      :null => true
      ## 首播
      t.boolean       :premiere,        :default => false

      t.integer       :created_by
      t.integer       :updated_by
      t.timestamps
    end
  end
end
