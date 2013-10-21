class CreateBroadcastUploads < ActiveRecord::Migration
  def change
    create_table :broadcast_uploads do |t|
      t.string     :file_name,    :null => false
      t.string     :note

      t.boolean    :skip_first_line,  :default => true

      ## 文件分析 ##
      ## 记录数
      t.integer    :count,        :null => false
      t.timestamp  :min_time,     :null => false
      t.timestamp  :max_time,     :null => false

      ## 上传用户
      t.integer    :created_by,   :null => false

      t.timestamps
    end
  end
end
