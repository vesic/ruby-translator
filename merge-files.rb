require 'colorize'

file1 = ARGV[0]
file2 = ARGV[1]
output_file = ARGV[2]

files = [file1, file2]

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