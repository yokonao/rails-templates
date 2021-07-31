# frozen_string_literal: true

def source_paths
  [__dir__]
end

# 依存Gemのチェック
%w[bundler rubocop].each do |gem|
  Gem::Specification.find_by_name(gem)
rescue Gem::MissingSpecError
  puts "#{gem} is missing!"
  puts %(Please run "gem install #{gem}"")
  exit 1
end

application do
  <<-CONFIG
  config.time_zone = 'Tokyo'
  CONFIG
end

# Gemの追加
gem_group :development, :test do
  gem 'factory_bot_rails' # specの中でモデルのインスタンスを生成するのに必要
  gem 'rexml' # rspecを動かすのに必要
  gem 'rspec-rails'
end

# DBをpostgresqlに変更する
template 'docker-compose-postgresql.yml.tt', 'docker-compose.yml'
template 'config/database.yml', force: true
run('mkdir tmp/pgdata')
run('docker compose up -d')

# tmuxinatorの設定ファイルを準備する
@root_dir = Dir.pwd
template '.tmuxinator.yml'

# asdfの設定ファイルをコピー
template '.tool-versions'

after_bundle do
  # https://github.com/rails/rails/issues/21700
  run 'spring stop'

  # TypeScript
  rails_command('webpacker:install:typescript')
  run('yarn add --dev fork-ts-checker-webpack-plugin')
  template 'tsconfig.json', force: true
  run('rm app/javascript/packs/*') # 初期ファイルはいらないので消す
  template 'app/javascript/packs/app.tsx' # 適当なサンプルファイルを追加
  template 'app/javascript/packs/application.ts' # このファイルだけはいる？何してるのかよくわからない

  # React-Router
  run('yarn add react-router-dom')
  run('yarn add -D @types/react-router-dom')

  # Axios
  run('yarn add axios @types/axios')

  # Reactコンポーネントを表示できるようにする
  generate(:controller, 'react --no-helper')
  template 'app/views/react/show.html.erb'
  route "get '/*react_path', to: 'react#show'"
  # モデルの生成
  generate(:scaffold, 'appointment name:text start_at:datetime end_at:datetime')
  generate(:controller, 'api/v1/appointments')

  # RSpecの下準備
  rails_command('generate rspec:install')
  template 'spec/rails_helper.rb' # RSpec設定の上書き、factory_bot_railsの設定が書かれている

  rails_command('db:create')
  rails_command('db:migrate')
  git :init
  git add: '.'
  git commit: %( -m 'Initial commit' )
end
