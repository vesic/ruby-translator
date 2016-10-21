require "http"
require "json"
require 'colorize'

apiKey = 'trnsl.1.1.20161019T122138Z.d4647318a3c3e16b.83ecebb28cc8c700faa31b58f632b63304e2bf08'
# apiKey = 'trnsl.1.1.20161019T122138Z.d4647318a3c3e16b.83ecebb28cc8c700faa31b58f632b63304e2bf08fake' #fake

en_words = [];
File.open('en-small.txt').each do |row|
  en_words << row.strip
end

# v-02
tr_words = []
en_words.each_slice(100) do |chunk|
  # text = chunk.inject { |memo, word| memo << "&text=" << word }
  text = ""
  chunk.each { |el| text << "&text=" << el }
  startTime = Time.now
  res = HTTP.get("https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{apiKey}#{text}&lang=en-de")
  res = JSON.parse(res);
  code = res["code"];
  if code.equal? 200
    translated_text = res["text"]
    tr_words.concat(translated_text)
  else
    tr_words << ">>>>> #{res} #{chunk}"
  end
  endTime = Time.now
  puts "Translated in #{(endTime - startTime).round(2).to_s.colorize(:green)} seconds"
end

File.open('fin-small.txt', 'w') do |file|
  words_written = 0
  tr_words.uniq.sort.each do |word|
    file.puts word
    puts "Line:#{words_written += 1} #{word.colorize(:yellow)}"
  end
end

# v-01
# tr_words = []
# en_words.each do |word|
#   startTime = Time.now
#   res = HTTP.get("https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{apiKey}&text=#{word}&lang=en-de")
#   res = JSON.parse(res);
#   translated = res["text"][0]
#   tr_words << translated
#   endTime = Time.now
#   puts "#{word.colorize(:yellow)} : #{translated.colorize(:green)} => #{(endTime - startTime).round(3)}"
# end

# File.open('fin-small.txt', 'w') do |file|
#   tr_words.each do |word|
#     file.puts word
#     # puts "#{word.colorize(:blue)} written"
#   end
# end

puts 'Finish'