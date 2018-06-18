module SqlMigrate
  class Config
    VALID_OPTIONS = [
      :host,
      :port,
      :database,
      :user,
      :password,
      :migrations_path,
      :logger,
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
      self.migrations_path = "migrations"
      self.logger = Logger.new(STDOUT)
    end
  end
end
