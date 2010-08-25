require 'active_record'

require_relative 'models/record'

module RDBB; module Runner
  class ActiveRecord
    def initialize
      ::ActiveRecord::Base.establish_connection(
        :adapter  => 'postgresql',
        # :host     => 'localhost',
        :username => 'rdbb',
        :password => 'rdbb',
        :database => 'rdbb_rails'
      )

      ::ActiveRecord::Schema.define do
        if table_exists? :records
          drop_table :records
        end

        create_table :records do |t|
          t.column :s, :string
        end
      end
    end

    def insert_simple
      record = Record.new( s: 'a string' )
      record.save
    end

    def prep_select_simple
      record = Record.new( s: 'a string' )
      record.id = 2
      record.save
    end
    def select_simple
      Record.find( 2 )
    end
  end
end; end
