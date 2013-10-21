class BroadcastsController < ApplicationController

  def index
    @broadcasts = Broadcast.all
  end



  def process_import

  end
end
