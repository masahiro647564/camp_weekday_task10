class AreasController < ApplicationController
  require 'net/http'
  require 'uri'

  def index
    @areas = Area.all
  end

  def search
  end

  def form
    @area = Area.new
    # 検索画面から送られてきた7桁の値をzipに格納
    zip = params[:zipcode]  
    params = URI.encode_www_form({zipcode: zip })
    # URIを解析し、hostやportをバラバラに取得できるようにする
    uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?#{params}")
    # リクエストパラメタを、インスタンス変数に格納
    @query = uri.query
    
    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      # 接続時に待つ最大秒数を設定
      http.open_timeout = 5
      # 読み込み一回でブロックして良い最大秒数を設定
      http.read_timeout = 10
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(uri.request_uri)
    end
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(response.body)
        # 表示用の変数に結果を格納
        if @result["status"] != 200
          redirect_to areas_search_path, alert: "#{@result["message"]}"
        end
        @area.zipcode = @result["results"][0]["zipcode"]
        @area.address1 = @result["results"][0]["address1"]
        @area.address2 = @result["results"][0]["address2"]
        @area.address3 = @result["results"][0]["address3"]
        @area.prefcode = @result["results"][0]["prefcode"]
        @area.kana1 = @result["results"][0]["kana1"]
        @area.kana2 = @result["results"][0]["kana2"]
        @area.kana3 = @result["results"][0]["kana3"]
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
  end

  def create
    @area = Area.new(area_params)
    if @area.save
      redirect_to areas_path, notice: "地域を登録しました｡"
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
