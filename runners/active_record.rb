require_relative '../models/activerecord/record'

module RDBB; module Runner
  class ActiveRecord
    def initialize
      ::ActiveRecord::Base.establish_connection(
        :adapter  => 'postgresql',
        :host     => 'localhost',
        :username => 'rdbb',
        :password => 'rdbb',
        :database => 'rdbb'
      )
    end

    def insert_simple
      record = Record.new( s: 'a string' )
      record.save
    end

    def prep_select_simple
      record = Record.new( id: 1, s: 'a string' )
      record.save
    end
    def select_simple
      Record.find( 1 )
    end
  end
end; end
