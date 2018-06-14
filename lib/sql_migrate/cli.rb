require "optparse"
require "sql_migrate"

module SqlMigrate
  class CLI
    attr_reader :options

    def self.run(argv = ARGV)
      cli = new
      cli.parse(argv)
      cli.execute
    end

    def initialize
      @options = {}
    end

    def parse(argv)
      args = argv.dup
      OptionParser.new do |opt|
        opt.version = ::SqlMigrate::VERSION
        opt.banner = "sql_migrate [options]"
        opt.on("-f CONFIG", "config file.") { |v| options[:config] = File.expand_path(v) }
        opt.parse!(args)
      end

      args
    end

    def execute
      puts "run!!"
    end
  end
end
