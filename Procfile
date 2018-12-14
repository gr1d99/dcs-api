release: bundle exec rake db:migrate
rails: puma -C config/puma.rb
sidekiq: bundle exec sidekiq -q default -q mailers
