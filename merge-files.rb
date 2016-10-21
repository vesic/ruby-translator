require 'highline'
require 'colorize'

cli = HighLine.new
files = []
want_more = true
output_file = nil

while want_more
  cli.choose do |menu|
    menu.prompt = "What's next?"
    menu.choice(:input) do 
      file = cli.ask('Input file name:')
      files << file
      puts
    end
    menu.choice(:output) do
      output_file = cli.ask('File to write combined input:')
      puts
    end
    menu.choice('current status') do
      puts "Input files: #{files.join(', ').colorize(:blue)}"
      puts "Output file: #{output_file.nil? ? 'none' : output_file.colorize(:blue)}"
      puts
    end
    menu.choice('Quit and save') do
      want_more = false
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
    end
  end
end
