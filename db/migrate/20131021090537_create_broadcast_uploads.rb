class CreateBroadcastUploads < ActiveRecord::Migration
  def change
    create_table :broadcast_uploads do |t|
      t.string     :file_name,    :null => false
      t.string     :note

      t.boolean    :skip_the_first_line,  :default => true
      t.boolean    :go_with_warning,      :default => false

      ## 文件分析 ##
      ## 记录数
      t.integer    :count,        :null => true
      t.timestamp  :min_time,     :null => true
      t.timestamp  :max_time,     :null => true



      ## 导入结果，  RUN, FAIL, SUCCESS
      t.string     :status,       :null => false


      ## 上传用户
      t.integer    :created_by,   :null => false

      t.timestamps
    end
  end
end
