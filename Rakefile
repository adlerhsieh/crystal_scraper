Dir["./lib/**/*.rb"].each {|file| require file }

desc "Scrape"
task :scrape do
  Database::Schema.new.maintain
  # Scraper.new(q: "crystal").get
end

namespace :db do
  task :reset do
    Database::Schema.new.rebuild
  end
end
