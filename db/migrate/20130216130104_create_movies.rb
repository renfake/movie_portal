class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      ## 题名（片名）
      t.string      :name,           :null => false

      ## 出品国家
      t.string      :country

      ## 出品年代
      t.date        :production_date

      ## 片种
      t.integer     :category_id

      ## 审批文号
      t.string       :auditing_file

      ## 所属年代
      t.integer     :age_id
      t.text        :age_note

      ## 时长
      t.integer     :runtime

      ## 色别
      t.integer     :color_id

      ## 影片规格
      t.integer     :format_id
      t.integer     :picture_id

      ## 影片介绍
      t.text        :plot_summary
      t.string      :theme
      t.text        :note

      t.timestamps
    end
  end
end
