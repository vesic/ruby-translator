require "http"
require "json"
require 'colorize'
require 'yaml'

apiKey = YAML.load_file("config.yml")["apiKey"]

input_file = ARGV[0]
output_file = ARGV[1]

en_words = [];
File.open(input_file).each do |row|
  en_words << row.strip
end

# v-02
tr_words = []
en_words.each_slice(100) do |chunk|
  # text = chunk.inject { |memo, word| memo << "&text=" << word }
  text = ""
  chunk.each { |el| text << "&text=" << el }
  startTime = Time.now
  res = HTTP.get("https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{apiKey}#{text}&lang=en-fi")
  res = JSON.parse(res);
  code = res["code"];
  if code.equal? 200
    translated_text = res["text"]
    # p translated_text
    translated_text.each do |word|
      inner = word.split(/\s*[ ,;:]\s*/)
      tr_words.concat(inner);
      # puts "#{inner}, #{tr_words.length}"
      # p tr_words.length
    end
    # inner = translated_text.split(/\s*[ ,;:]\s*/) # split each translation
    # tr_words.concat(translated_text)
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
    file.puts word if word.index(/[^[:alnum:]]/).nil?
    puts "Line:#{words_written += 1} #{word.colorize(:yellow)}"
  end
end

puts "Completed original:#{tr_words.length} final:#{tr_words.uniq.length}"
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
