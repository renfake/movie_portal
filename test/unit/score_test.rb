# coding: utf-8
require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  test "should be persist" do
    @score = Score.new(:item_name => "故事性", :description => "这一项主要可以说指的主要是影片的内容层面")
    assert !@score.save, "Persist error."
  end
end