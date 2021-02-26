class ShopsController < ApplicationController
  def index
    api_key = "c7234439fa91940d"
    url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{api_key}&format=json"

    large_area_url = "http://webservice.recruit.co.jp/hotpepper/large_area/v1/?key=#{api_key}&format=json"
    large_area_url=URI.encode(large_area_url) #エスケープ
    uri = URI.parse(large_area_url)
    json = Net::HTTP.get(uri)
    @before_large_area_select = JSON.parse(json)["results"]["large_area"]
    @large_area_select = @before_large_area_select.map { |r| ["#{r['name']}", "#{r['code']}"] }

    middle_area_url = "http://webservice.recruit.co.jp/hotpepper/middle_area/v1/?key=#{api_key}&format=json"
    middle_area_url=URI.encode(middle_area_url) #エスケープ
    uri = URI.parse(middle_area_url)
    json = Net::HTTP.get(uri)
    @before_middle_area_select = JSON.parse(json)["results"]["middle_area"]
    @middle_area_select = @before_middle_area_select.map { |r| ["#{r['name']}", "#{r['code']}"] }
    @large_area_group = []
    @before_large_area_select.each do |l|
      a = []
      @before_middle_area_select.each do |m|
        if m["large_area"]["name"] == l["name"]
          a << [["#{l['code']}"], ["#{m['name']}", "#{m['code']}"]]
        end
      end
      @large_area_group << a
    end
    @results = nil

    if params[:search]
      word = params[:search]
      word = word.gsub(/[\s+　+]/, ',')
      url << "&keyword=" << word#名前で検索
      url = URI.encode(url) #エスケープ
      uri = URI.parse(url)
      json = Net::HTTP.get(uri)
      @results = JSON.parse(json)["results"]["shop"]
    end

    if params[:large_area]
      large_area_code = params[:large_area]
      url << "&large_area=" << large_area_code
      uri = URI.parse(url)
      json = Net::HTTP.get(uri)
      @results = JSON.parse(json)["results"]["shop"]
    end

    if params[:middle_area]
      middle_area_code = params[:middle_area]
      url << "&middle_area=" << middle_area_code
      uri = URI.parse(url)
      json = Net::HTTP.get(uri)
      @results = JSON.parse(json)["results"]["shop"]
    end


  end
end
