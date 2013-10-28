# coding: utf-8
class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, :null => false
      t.timestamps
    end
    %w( 故事片 译制片 数字电影 戏曲片 舞台艺术片 美术片 新闻片 记录片
        科教片 电视剧 专题片 动画片 皮影戏 短片 舞台片 栏目 木偶片/台标 儿童片).each do |name|
      Category.create! :name => name
    end
  end
end
