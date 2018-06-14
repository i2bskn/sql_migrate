module SqlMigrate
  class Migrator
    attr_accessor :config

    VERSION_TABLE_NAME = "migrate_versions".freeze

    def initialize(config = nil)
      @config = config || Config.new
    end

    def migrate
      create_migrate_versions_if_not_exist
      versions = applied_versions
      migration_files.sort.each do |migration|
        next if versions.include?(migration)
        sql_text = File.read(migration)
        sql_text.split(";").each do |sql|
          next if sql.strip.empty?
          connection.query(sql)
        end
        connection.query("insert into #{VERSION_TABLE_NAME} (`version`) values (\"#{migration}\")")
      end
    end

    def create_migrate_versions_if_not_exist
      unless table_names.include?(VERSION_TABLE_NAME)
        sql = <<-EOS
          create table `#{VERSION_TABLE_NAME}` (
            `version` varchar(256),
            PRIMARY KEY (`version`)
          ) ENGINE=InnoDB DEFAULT CHARSET=utf8
        EOS
        connection.query(sql)
      end
    end

    def table_names
      connection.query("show tables", as: :array).to_a.flatten
    end

    def applied_versions
      connection.query("select * from #{VERSION_TABLE_NAME}", as: :array).to_a.flatten
    end

    def migration_files
      Dir.glob(File.join(config.migrations_path, "*"))
    end

    private

      def connection
        @connection ||= Mysql2::Client.new(**db_options)
      end

      def db_options
        options = {
          host: config.host,
          port: config.port,
          database: config.database,
          username: config.user,
        }
        options[:password] = config.password if config.password
        options
      end
  end
end
