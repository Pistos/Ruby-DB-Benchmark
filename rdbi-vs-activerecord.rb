# require 'better-benchmark'
require 'active_record'

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
  end

  def run
    t = Record.new( s: 'a string' )
    t.save
  end
end

bench = RubyDatabaseBenchmark.new
bench.run
