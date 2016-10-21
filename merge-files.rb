require 'colorize'

files = ['out1.txt', 'out2.txt']
output_file = 'combined.txt'
combined = []

files.each do |file|
  File.open(file).each do |row|
    combined << row.strip
  end
end

File.open(output_file, 'w') do |file|
  words_written = 0
  combined.uniq.sort.each do |word|
    file.puts word
    puts "Line:#{words_written += 1} #{word.colorize(:yellow)}"
  end
end