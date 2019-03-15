class AreasController < ApplicationController
  require 'net/http'
  require 'uri'
  #helperから読み込む
  include AreasHelper

  def index
    @areas = Area.all
  end

  def search
  end

  def form
    @area = Area.new
    api_request(params[:zipcode])
  end

  def create
    @area = Area.new(area_params)
    if @area.save
      redirect_to root_path, notice: "地域を登録しました｡"
    else
      flash.now[:alert] = "Validation failed: #{@area.errors.full_messages.join}"
      render :form
    end
  end

  private

    def area_params
      params.require(:area).permit(:zipcode, :prefcode, :address1, :kana1, :address2, :kana2, :address3, :kana3, :introduction)
    end
end
