# coding: utf-8
##影片评分元数据表，设计为树形结构，兼容将来的细分项，例如
## 故事性 ->
##          题材
##          情节
##          节奏
## 观赏性 ->
##          画面质量
##          声音效果
##          演员阵容
##          特技制作
##          动作设计
##          喜剧效果
##          画面剪辑
class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      ##影片评项父节点ID
      t.integer   :parent_id,       :null => true
      ##评分项名称
      t.string    :item_name,       :null => false
      ##该项目的最小分数
      t.integer   :min_score,       :null => false,   :default => 1
      ##该项目的最大分数
      t.integer   :max_score,       :null => false,   :default => 5
      ##分数递增规则，例如1,则表示 1,2,3,4,5...; 2则表示1,3,5...
      t.integer   :step,            :null => false,   :default => 1
      ##该项目描述信息
      t.string    :description
    end
  end
end
