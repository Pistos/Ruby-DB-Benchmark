require 'better-benchmark'
require 'active_record'
require 'rdbi'
require 'rdbi/driver/postgresql'

require_relative 'models/activerecord/record'

class RubyDatabaseBenchmark
  DB_USER = 'rdbb'
  DB_PASSWORD = 'rdbb'
  DB_DATABASE = 'rdbb'

  def initialize
    dir = File.dirname( __FILE__ )
    `cat #{dir}/schemata/postgresql.sql | psql -U #{DB_USER} #{DB_DATABASE}`

    ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :host     => "localhost",
      :username => DB_USER,
      :password => DB_PASSWORD,
      :database => DB_DATABASE
    )

    @dbh = RDBI.connect( :PostgreSQL, database: DB_DATABASE, username: DB_USER, password: DB_PASSWORD )
  end

  def run
    result = Benchmark.compare_realtime(
      :iterations => 10,
      :inner_iterations => 2000,
      :verbose => true
    ) { |iteration|
      s = 'a string'
      t = Record.new( s: s )
      t.save
    }.with { |iteration|
      s = 'a string'
      @dbh.execute( "INSERT INTO records ( s ) VALUES ( ? )", s )
    }

    Benchmark.report_on result

  end
end

bench = RubyDatabaseBenchmark.new
bench.run
