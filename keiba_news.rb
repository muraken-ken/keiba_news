# 【名  称】競馬実況ホームページ記事抽出スクリプト
# 【仕  様】ラジオNIKKEI競馬実況ホームページから記事データを読み込み
#           馬名毎に記事ファイルを編集出力する
# 【来  歴】Ver 1.0 （蛸坊主さんのスクリプトを参考に作成）

require 'nokogiri'
require 'open-uri'
require 'pp'

URL = 'http://keiba.radionikkei.jp/keiba/news/headline/'.freeze

def open_html(url)
  Nokogiri::HTML(URI.open(URI.parse(url)))
end

def url_list(url)
  news_list = open_html(url)
  puts 'サイトにアクセスしています...'
  sleep 2
  url_list = []
  news_list.css('.detail_kjnet_kiji ul li a').each do |elem|
    url_list << elem[:href]
  end
  url_list.reverse
end

def done?(file_name, str)
  File.open("/mnt/c/TFJV/EX_DATA/#{file_name}", 'a+:sjis:utf-8').read.include?(str)
end

url_list = url_list(URL)

url_list.each do |url|
  article = open_html(url)
  sleep 2
  p title = article.css('.detail_kjnet_kiji dl dt').text
  update_at = article.css('.detail_kjnet_kiji dl dd').text
  next if done?('log.txt', update_at)

  body = article.css('.detail_topics').inner_html.gsub!(/<br>/, "\n")
  horse_names = body.scan(/\p{Katakana}[\p{Katakana}ー]{1,8}/).uniq
  next unless horse_names

  horse_names.each do |name|
    p file_name = "#{name}.txt"
    next if done?(file_name, update_at)

    File.open("/mnt/c/TFJV/EX_DATA/#{file_name}", 'a+:sjis:utf-8') do |f|
      f.puts title
      f.puts
      f.puts "■ #{update_at}"
      f.puts body
      f.puts '【出典】ラジオNIKKEI競馬実況web http://keiba.radionikkei.jp/'
      f.puts "【日時】#{Time.now.strftime('%Y/%m/%d %H:%M:%S')}"
      f.puts '-' * 80
    end
  end
  File.open('/mnt/c/TFJV/EX_DATA/log.txt', 'a+:sjis:utf-8') do |f|
    f.puts update_at
  end
end
