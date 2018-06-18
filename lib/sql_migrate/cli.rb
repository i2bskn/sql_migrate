require "optparse"
require "yaml"
require "sql_migrate"

module SqlMigrate
  class CLI
    attr_reader :config

    def self.run(argv = ARGV)
      cli = new
      cli.parse(argv)
      cli.execute
    end

    def initialize
      @config = Config.new
    end

    def parse(argv)
      args = argv.dup
      options = {}
      OptionParser.new do |opt|
        opt.version = VERSION
        opt.banner = "sql_migrate [options]"
        opt.on("-f CONFIG", "config file.") { |v| options[:config] = v }
        opt.parse!(args)
      end

      load_from_config(options.delete(:config)) if options.has_key?(:config)
      config.merge(options)
      config.migrations_path = args.first if args.size.positive?

      args
    end

    def execute
      migrator = Migrator.new(config)
      migrator.migrate
    end

    private

      def load_from_config(path)
        path = File.expand_path(path)
        yaml = YAML.load_file(path)
        config.merge(yaml)
      end
  end
end
