Dir['./lib/**/*.rb'].each { |file| require file }

desc 'Scrape'
task :scrape do
  Connector.new(
    q: 'crystal',
    per_page: 8
  ).iterate
end

namespace :db do
  task :reset do
    Database::Schema.new.reset
  end
end
