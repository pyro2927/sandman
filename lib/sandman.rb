require "sandman/version"
require "github_api"
require "bitbucket_rest_api"

module Sandman
  @config = {:accounts => []}
  @providers = Array.new

  def self.filter_args(args)
    Sandman.init
    if args.count > 1
      # try to automatically detect if we're being handed a file or key string
      key = args[1]
      if key.start_with?("ssh") == false && File.exist?(key)
        key = File.read(key)
      end
      if args.count > 2
        name = args[2]
      else
        name = `hostname`.strip
      end
      command = args[0]
      if command == "add"
        Sandman.add_key_to_providers(key, name)
      elsif command.start_with?("rem") || command.start_with?("del")
        Sandman.remove_key_from_providers(key)
      end
    elsif args.count == 1
      command = args[0]
      if command == "show"
        Sandman.show_keys
      else if command == "sync" || command == "merge"
        #TODO: merge this stuff
      end
    end
  end

  def self.init
    Sandman.configure_with "#{Dir.home}/.sandman"
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

  def self.merge_keys_to_services

  end

  def self.add_key_to_provider(p, key = "", title = "")
    begin
      if p.kind_of? Github::Client
        p.users.keys.create({:title => title, :key => key})
        puts "Key added to GitHub"
      elsif p.kind_of? BitBucket::Client
        p.users.account.new_key(p.login, {:label => title, :key => key})
        puts "Key added to BitBucket"
      end
    rescue Exception => e
      puts e.to_s
    end
  end

  def self.add_key_to_providers(key = "", title = "")
    puts "Adding #{key} to providers..."
    @providers.each do |p|
      Sandman.add_key_to_provider(p, key, title)
    end
  end

  def self.remove_key_from_provider(p, key)
    begin
      if p.kind_of? Github::Client
        p.users.keys.delete(key[:id])
        puts "Key removed from GitHub"
      elsif p.kind_of? BitBucket::Client
        p.users.account.delete_key(p.login, key[:pk])
        puts "Key removed from BitBucket"
      end
    rescue Exception => e
      puts e.to_s
    end
  end

  def self.remove_key_from_providers(key = "")
    puts "Removing #{key} from providers..."
    @providers.each do |p|
      Sandman.keys_for_provider(p).each do |k|
        if ( k[:key].split(" ")[0..1].join(" ").start_with?(key) || (k[:title].nil? == false && k[:title].downcase == key.downcase) || (k[:label].nil? == false && k[:label].downcase == key.downcase) )
          Sandman.remove_key_from_provider(p, k)
        end
      end
    end
  end

  def self.show_keys
    @providers.each do |p|
      puts p.class.name.split("::").first + ": " + p.login
      Sandman.keys_for_provider(p).each do |k|
        if p.kind_of? Github::Client
          puts "\t#{k[:title]}: #{k[:key][0..50]}"
        elsif p.kind_of? BitBucket::Client
          puts "\t#{k[:label]}: #{k[:key][0..50]}"
        end
      end
    end
  end
end
