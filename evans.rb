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

# DBをpostgresqlに変更する
template 'docker-compose-postgresql.yml.tt', 'docker-compose.yml'
template 'config/database.yml', force: true
run('mkdir tmp/pgdata')
run('docker compose up -d')

# tmuxinatorの設定ファイルを準備する
@root_dir = Dir.pwd
template '.tmuxinator.yml'

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
  generate(:scaffold, 'booking name:text start:datetime end:datetime')
  generate(:controller, 'api/v1/bookings')

  rails_command('db:migrate')
  git :init
  git add: '.'
  git commit: %( -m 'Initial commit' )
end
