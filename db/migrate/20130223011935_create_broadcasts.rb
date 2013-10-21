# coding: utf-8
class CreateBroadcasts < ActiveRecord::Migration
  def change
    create_table :broadcasts do |t|
      ## 周次
      t.integer       :week, :null => false
      ## 日期 & 开始时间
      t.timestamp     :start_datetime, :null => false
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

      ## 时长
      t.integer       :duration,         :null => true

      ## 状态: 正式，Draft(由当前的周或未来周的编排表生成)
      t.string        :status,           :null => false

      ## 记录生成方式: 手动生成（manual), 导入（upload), 编排表产生(system)
      t.string        :come_from,        :null => false

      ## 记录是导入产生是保存导入ID，便于批量删除
      t.integer       :broadcast_upload_id

      ## 记录更新的用户
      t.integer       :created_by,      :null => false
      t.integer       :updated_by,      :null => false
      t.timestamps
    end
  end
end
