# frozen_string_literal: true

# rails new booking-sample -d postgresql --webpack=react -m rails-templates/evans.rb

def source_paths
  [__dir__]
end

%w[bundler rubocop].each do |gem|
  Gem::Specification.find_by_name(gem)
rescue Gem::MissingSpecError
  puts "#{gem} is missing!"
  puts %(Please run "gem install #{gem}"")
  exit 1
end

template 'docker-compose-postgresql.yml.tt', 'docker-compose.yml'
template 'config/database.yml', 'config/database.yml', force: true
run('mkdir tmp/pgdata')
run('docker compose up -d')

after_bundle do
  # https://github.com/rails/rails/issues/21700
  run 'spring stop'
  generate(:scaffold, 'booking name:text start:datetime end:datetime')
  rails_command('db:migrate')
  git :init
  git add: '.'
  git commit: %( -m 'Initial commit' )
end
