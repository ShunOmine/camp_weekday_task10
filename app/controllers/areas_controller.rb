class AreasController < ApplicationController
  require 'uri'
  require 'net/http'
  require 'json'

  def index
    @areas = Area.all
  end

  def search
    @area = Area.new
    zipcode = params[:zipcode]
    uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?zipcode=#{zipcode}")
    response = Net::HTTP.get_response(uri)
    @json = JSON.parse(response.body)
    if @json["status"].to_i != 200
      flash.now[:alert] = "#{@json["message"]}"
    elsif @json["status"].to_i == 200
      @query = uri.query
      response = Net::HTTP.get_response(uri)
      begin
        # responseの値に応じて処理を分ける
        case response
          # 成功した場合
        when Net::HTTPSuccess
          # responseのbody要素をJSON形式で解釈し、hashに変換
          @result = JSON.parse(response.body)
          # 表示用の変数に結果を格納
          @zipcode = @result["results"][0]["zipcode"]
          @address1 = @result["results"][0]["address1"]
          @kana1 = @result["results"][0]["kana1"]
          @address2 = @result["results"][0]["address2"]
          @kana2 = @result["results"][0]["kana2"]
          @address3 = @result["results"][0]["address3"]
          @kana3 = @result["results"][0]["kana3"]
          @prefcode = @result["results"][0]["prefcode"]
          flash.now[:notice] = "地域が見つかりました。"
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
  end

  def create
    @area = Area.new(set_params)
    respond_to do |format|
      if @area.save
        format.html { redirect_to root_path, notice: '地域を登録しました。' }
        format.json { render :index, status: :created, location: @task }
      else
        format.html { render :search, alert: "エラーが発生しました。" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_params
      params.require(:area).permit(:zipcode, :prefcode, :address1, :address2, :address3, :kana1, :kana2, :kana3, :introduction)
    end
end
