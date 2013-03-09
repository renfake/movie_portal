# coding: utf-8
class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name,     :null => false
      t.string :code
      t.timestamps
    end

    %w( 中国大陆 中国台湾 中国香港 美国 英国 法国 日本 德国 加拿大 印度 ).each do |name|
      Country.create! :name => name
    end
  end
end
