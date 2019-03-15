class AreasController < ApplicationController

  def index
    @areas = Area.all
  end

  def search
  end
end
