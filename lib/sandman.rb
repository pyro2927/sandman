require "sandman/version"

module Sandman
  @config = {:accounts => []}

  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML config file not found, using defaults")
    rescue Psych::SyntaxError
      log(:warning, "YAML config file contains invalid syntax, using defaults")
    end

    configure(config)
  end

  def self.write_config(path_to_yaml_file)
    IO.write(path_to_yaml_file, @config.to_yaml)
  end

  def self.config
    @config
  end

end
