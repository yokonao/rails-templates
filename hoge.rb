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

file_content = %(version: "3.8"
  services:
    db:
      image: postgres:13.3
      ports:
        - 5432:5432
      environment:
        POSTGRES_PASSWORD: postgresql
        POSTGRES_USER: postgresql
        POSTGRES_DB: postgresql_development
        PGDATA: /var/lib/postgresql/data/pgdata
      volumes:
        - ./tmp/pgdata:/var/lib/postgresql/data/pgdata
  )

puts file_content
