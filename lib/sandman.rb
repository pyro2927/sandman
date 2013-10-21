require "sandman/version"
require "github_api"
require "bitbucket_rest_api"

module Sandman
  @config = {:accounts => []}
  @providers = Array.new

  def self.init
    Sandman.configure_with "config"
  end

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

  def self.configure(opts = {})
    @config = opts
    opts[:accounts].each do |acct|
      provider = Kernel.const_get(acct[:type]).new acct
      @providers << provider
    end
  end

  def self.write_config(path_to_yaml_file)
    IO.write(path_to_yaml_file, @config.to_yaml)
  end

  def self.config
    @config
  end

  def self.keys_for_provider(p)
    if p.kind_of? Github::Client
      p.users.keys.all(p.login).body
    elsif p.kind_of? BitBucket::Client
      p.users.account.keys(p.login)
    end
  end

  def self.all_keys
    keys = Array.new
    @providers.each do |p|
      keys << Sandman.keys_for_provider(p)
    end
    keys.flatten
  end

  def self.show_keys
    @providers.each do |p|
      puts p.class.name.split("::").first + ": " + p.login
      Sandman.keys_for_provider(p).each do |k|
        puts "\t" + k[:key]
      end
    end
  end
end
