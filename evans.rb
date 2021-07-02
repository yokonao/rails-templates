%w[bundler rubocop].each do |gem|
  next if Gem::Specification.find_by_name(gem)

  run "gem install #{gem}"
  Gem.refresh
  Gem.activate(component)
end

run_bundle
generate(:scaffold, 'booking name:text start:datetime end:datetime')
rails_command('db:migrate')

after_bundle do
  git :init
  git add: '.'
  git commit: %( -m 'Initial commit' )
end
