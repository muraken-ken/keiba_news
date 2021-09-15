# 【名  称】競馬実況ホームページ記事抽出スクリプト
# 【仕  様】ラジオNIKKEI競馬実況ホームページから記事データを読み込み
#           馬名毎に記事ファイルを編集出力する
# 【来  歴】Ver 0.01 試作（蛸坊主さんのスクリプトを参考に作成）

require 'nokogiri'
require 'open-uri'
require 'pp'

URL = 'http://keiba.radionikkei.jp/keiba/news/headline/'

def get_html(url)
  url = URI.parse(url)
  Nokogiri::HTML(URI.open(url))
end

news_list = get_html(URL)
sleep 5

url_list = []
news_list.css('.detail_kjnet_kiji ul li a').each do |elem|
  url_list << elem[:href]
end

url_list.reverse!

article = get_html(url_list[5])
sleep 5
title = article.css('.detail_kjnet_kiji dl dt').text
update_at = article.css('.detail_kjnet_kiji dl dd').text
body = article.css('.detail_topics').inner_html.gsub!(/<br>/, "\n")

pp title
pp update_at
pp body


# news_url_lists.each do |elem|
#   puts url = elem[:href]
# end
