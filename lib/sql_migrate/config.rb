module SqlMigrate
  class Config
    VALID_OPTIONS = [
      :host,
      :port,
      :database,
      :user,
      :password,
      :migrations_paths,
      :logger,
      :dryrun,
      :verbose,
    ].freeze

    attr_accessor *VALID_OPTIONS

    def initialize
      reset
    end

    def merge(params)
      params.each do |key, value|
        self.send("#{key}=", value)
      end
      self
    end

    def reset
      self.host = "localhost"
      self.port = 3306
      self.user = "root"
      self.migrations_paths = ["migrations"]
      self.logger = default_logger
      self.dryrun = false
      self.verbose = false
    end

    private

      def default_logger
        logger = Logger.new(STDOUT)
        logger.formatter = proc { |severity, datetime, progname, message|
          "#{datetime.strftime('%F %H:%M:%S.%N')}\t#{severity}\t#{message}\n"
        }
        logger
      end
  end
end
