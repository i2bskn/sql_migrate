# SqlMigrate

## Installation

```
$ gem install sql_migrate
```

## Usage

```
$ tree path/to/migrations
migrations
├── 0001_xxxx.sql
├── 0002_xxxx.sql
└── 0003_xxxx.sql
$ export MYSQL_PWD=secret
$ sql_migrate -h mysql.example.com -u root -v -n -d dbname path/to/migrations        # dry run
$ sql_migrate -h mysql.example.com -u root -v --applied -d dbname path/to/migrations # make it applied
$ sql_migrate -h mysql.example.com -u root -v -d dbname path/to/migrations           # apply migrations
```

### Options

```
$ sql_migrate --help
sql_migrate [options] MIGRATIONS_PATH
    -h HOST
    -d DATABASE
    -u USER
    -p PASSWORD
    -v, --verbose
    -n, --dry-run
        --applied
    -f CONFIG
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/i2bskn/sql_migrate.
