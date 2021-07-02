%w[bundler rubocop].each do |gem|
  Gem::Specification.find_by_name(gem)
rescue Gem::MissingSpecError
  puts "#{gem} is missing!"
  puts %(Please run "gem install #{gem}"")
  exit 1
end

run_bundle
generate(:scaffold, 'booking name:text start:datetime end:datetime')
rails_command('db:migrate')

after_bundle do
  git :init
  git add: '.'
  git commit: %( -m 'Initial commit' )
end
