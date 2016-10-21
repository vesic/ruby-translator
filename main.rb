require "http"
require "json"
require 'colorize'

# apiKey = 'trnsl.1.1.20161019T122138Z.d4647318a3c3e16b.83ecebb28cc8c700faa31b58f632b63304e2bf08' # vesic.dusan
apiKey = 'trnsl.1.1.20161021T082649Z.2c580cbfb6e38e41.1cac476ae2aacbb9b1b1ed18b3c33cf55083daa5' # vesic.dusan.1
# apiKey = 'trnsl.1.1.20161019T122138Z.d4647318a3c3e16b.83ecebb28cc8c700faa31b58f632b63304e2bf08fake' #fake

output_file = 'out2.txt';

en_words = [];
File.open('en-02.txt').each do |row|
  en_words << row.strip
end

# v-02
tr_words = []
en_words.each_slice(100) do |chunk|
  # text = chunk.inject { |memo, word| memo << "&text=" << word }
  text = ""
  chunk.each { |el| text << "&text=" << el }
  startTime = Time.now
  res = HTTP.get("https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{apiKey}#{text}&lang=en-fin")
  res = JSON.parse(res);
  code = res["code"];
  if code.equal? 200
    translated_text = res["text"]
    tr_words.concat(translated_text)
    endTime = Time.now
    puts "Translated #{chunk.length.to_s.colorize(:red)} words in #{(endTime - startTime).round(2).to_s.colorize(:green)} seconds"
  else
    tr_words << ">>>>> #{res} #{chunk}"
    puts "Error #{code}"
  end
end

File.open(output_file, 'w') do |file|
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

puts 'Completed'