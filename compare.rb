require 'better-benchmark'
require 'active_record'
require 'rdbi'
require 'rdbi/driver/postgresql'

require_relative 'runners/rdbi'
require_relative 'runners/active_record'

module RDBB

  class RubyDatabaseBenchmark
    DB_USER = 'rdbb'
    DB_PASSWORD = 'rdbb'
    DB_DATABASE = 'rdbb'

    def print_usage
      puts "ruby #{$0} <DB lib 1> <DB lib 2> <benchable> [benchable...]"
    end

    def initialize
      @benchables = []

      argv = ARGV.dup
      while argv.any?
        arg = argv.shift
        case arg
        when '--help'
          print_usage
          exit 1
        else
          if @runner1.nil?
            @runner1 = RDBB::Runner.const_get( arg.to_sym ).new
          elsif @runner2.nil?
            @runner2 = RDBB::Runner.const_get( arg.to_sym ).new
          else
            @benchables << arg.to_sym
          end
        end
      end

      if @runner1.nil? || @runner2.nil? || @benchables.empty?
        print_usage
        exit 1
      end

      dir = File.dirname( __FILE__ )
      `cat #{dir}/schemata/postgresql.sql | psql -U #{DB_USER} #{DB_DATABASE}`

    end

    def run
      @benchables.each do |method|
        puts "*" * 79
        puts "* #{method}"

        prep_method = "prep_#{method}".to_sym
        if @runner1.respond_to? prep_method
          @runner1.send prep_method
        end
        if @runner2.respond_to? prep_method
          @runner2.send prep_method
        end

        result = Benchmark.compare_realtime(
          :iterations => 10,
          :inner_iterations => 2000,
          :verbose => true
        ) { |iteration|
          @runner1.send method
        }.with { |iteration|
          @runner2.send method
        }

        Benchmark.report_on result
      end
    end
  end

end

bench = RDBB::RubyDatabaseBenchmark.new
bench.run
