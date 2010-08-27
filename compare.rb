require 'better-benchmark'

require_relative 'runners/rdbi/runner'
require_relative 'runners/active_record/runner'

module RDBB

  class RubyDatabaseBenchmark

    def print_usage
      puts "ruby #{$0} [-i <inner iterations>] <DB lib 1> <DB lib 2> <benchable> [benchable...]"
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
        when '-i', '--iterations-inner'
          @inner_iterations = argv.shift.to_i
        when '--iterations-outer'
          @outer_iterations = argv.shift.to_i
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

    end

    def run
      @benchables.each do |method|
        puts "*" * 79
        puts "* #{method}"

        prep_method = "prep_#{method}".to_sym
        puts "* Running #{@runner1.class} preparations..."
        if @runner1.respond_to? prep_method
          @runner1.send prep_method
        end
        puts "* Running #{@runner2.class} preparations..."
        if @runner2.respond_to? prep_method
          @runner2.send prep_method
        end

        puts "* Comparing libs..."
        result = Benchmark.compare_realtime(
          :iterations => @outer_iterations || 10,
          :inner_iterations => @inner_iterations || 1000,
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
