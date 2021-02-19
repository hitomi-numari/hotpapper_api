class ShopsController < ApplicationController
  def index
    url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=c7234439fa91940d"

    if params[:search]
    word=params[:search]
    word = word.gsub(/[\s　]/, ',')
    url << "&keyword=" << word << "&format=json"
    url=URI.encode(url)
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)

    @results = JSON.parse(json)["results"]["shop"]
    end
  end
end
