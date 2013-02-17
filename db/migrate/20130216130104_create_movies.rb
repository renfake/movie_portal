class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      ## 题名（片名）
      t.string      :name,           :null => false

      ## 出品国家
      t.string      :product_country,:null => false

      ## 出品年代
      t.date        :product_date,   :null => false

      ## 审批文号
      t.string       :auditing_file

      ## 所属年代
      t.integer     :age_id,          :null => false
      t.text        :age_note

      ## 时长
      t.integer     :runtime,         :null => false

      ## 色别
      t.integer     :color_id,        :null => false

      t.timestamps
    end
  end
end
