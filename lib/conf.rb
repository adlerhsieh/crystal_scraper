require 'yaml'

class Conf
  def self.yml
    YAML.load_file(File.join(File.dirname(__FILE__), '../config/application.yml'))
  end
end
