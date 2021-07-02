# frozen_string_literal: true

p File.dirname(__FILE__)
p File.join(File.dirname(__FILE__))
p File.expand_path(File.join(File.dirname(__FILE__)))
# colored

%w[bundler rubocop].each do |gem|
  Gem::Specification.find_by_name(gem)
rescue Gem::MissingSpecError
  puts "#{gem} is missing!"
  puts %(Please run "gem install #{gem}"")
end
