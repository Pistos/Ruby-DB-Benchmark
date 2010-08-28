require 'sequel'

module RDBB; module Runner
  class Sequel
    def initialize
      db_user = 'rdbb'
      db_database = 'rdbb_sequel'

      @dbh = ::Sequel.connect( 'postgres://rdbb:password@localhost/rdbb_sequel')

      if @dbh.table_exists? :records
        @dbh.drop_table :records
      end

      @dbh.create_table :records do
        primary_key :id
        String :s
      end

      @records = @dbh[ :records ]
    end

    def insert_simple
      @records.insert( s: 'a string' )
    end

    def prep_select_simple
      @records.insert( id: 2, s: 'a string' )
    end
    def select_simple
      @records.where( id: 2 )
    end

    def prep_select_simple_many
      (1..1000).each do |i|
        @records.insert( id: i, s: i )
      end
    end
    def select_simple_many
      (1..1000).each do |i|
        @records.where( id: i )
      end
    end

    def prep_update_simple
      @records.insert( id: 3, s: 'a string' )
    end
    def update_simple
      @records.where( id: 3 ).update( s: Time.now.to_f )
    end
  end
end; end
