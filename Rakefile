Dir["./lib/**/*.rb"].each {|file| require file }

desc "Scrape"
task :scrape do
  Scraper.new(q: "crystal").get
end
