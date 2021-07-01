generate(:scaffold, "booking name:text start:datetime end:datetime")
rails_command("db:migrate")

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
