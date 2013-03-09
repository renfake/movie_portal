# coding: utf-8
class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string      :name,    :null => false
      t.timestamps
    end

    %w( 武打 冒险 传奇 战争 喜剧 动作 爱情 犯罪 惊悚 奇幻 悬疑 传记 动画 音乐 历史 儿童 体育 戏曲 ).each do |name|
      Genre.create! :name => name
    end
  end
end
