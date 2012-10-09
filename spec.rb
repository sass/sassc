#!/usr/bin/env ruby

searchpath = ARGV[0] || ""

messages = []
warnings = []
worked = 0
spec_count = 0

puts("Running tests in #{searchpath}..\n\n")

Dir["**/input.*"].each do |input_file|
  if input_file[0..(searchpath.length - 1)] == (searchpath)
    spec_count += 1
    spec_dir = File.dirname(input_file)

    sassc_file    = File.join(spec_dir, "sassc_output.css")
    sass_file     = File.join(spec_dir, "sass_output.css")
    expected_file = File.join(spec_dir, "expected_output.css")

    `./bin/sassc #{input_file} > #{sassc_file}`
    `sass #{input_file} > #{sass_file}`

    sassc_output    = File.read(sassc_file)
    sass_output     = File.read(sass_file)
    expected_output = File.read(expected_file)

    if sassc_output.strip != sass_output.strip
      warning = "Problem with Ruby compat in #{input_file}\n"
      warning << `diff -rub #{sass_file} #{sassc_file}`
      warnings << warning
    end

    if expected_output.strip != sassc_output.strip
      print "F"
      message = "Failed test #{spec_dir}\n"
      warning << `diff -rub #{expected_file} #{sassc_file}`
      messages << message
    else
      worked += 1
      print "."
    end

    `rm "#{sassc_file}"`
    `rm "#{sass_file}"`
  end
end

puts("\n\n#{worked}/#{spec_count} Specs Passed!")

if warnings.length > 0 
  warn = ([""] + warnings).join("\n-----WARN------\n")
  puts("\n#{warn}")
end

if messages.length > 0 
  puts("\n================================\nTEST FAILURES!\n\n")
  puts(messages.join("\n-----------\n"))
  puts("\n")
  exit(1)
else
  puts("YOUWIN!")
  exit(0)
end

