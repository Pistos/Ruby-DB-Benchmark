require 'rdbi'
require 'rdbi/driver/postgresql'

module RDBB; module Runner
  class RDBI
    def initialize
      db_user = 'rdbb'
      db_database = 'rdbb_rdbi'

      dir = File.dirname( __FILE__ )
      `cat #{dir}/schema.sql | psql -U #{db_user} #{db_database}`

      @dbh = ::RDBI.connect( :PostgreSQL, database: db_database, username: db_user, password: 'rdbb' )
    end

    def insert_simple
      @dbh.execute( "INSERT INTO records ( s ) VALUES ( ? )", 'a string' )
    end

    def prep_select_simple
      @id = Time.now.to_i
      @dbh.execute( "INSERT INTO records ( id, s ) VALUES ( ?, ? )", @id, 'a string' )
      @st = @dbh.prepare( "SELECT * FROM records WHERE id = ?" )
    end
    def select_simple
      @st.execute( @id ).fetch
    end

    def prep_select_simple_many
      @dbh.execute "DELETE FROM records"
      (1..1000).each do |i|
        @dbh.execute( "INSERT INTO records ( id, s ) VALUES ( ?, ? )", i, i )
      end
      @st = @dbh.prepare( "SELECT * FROM records WHERE id = ?" )
    end
    def select_simple_many
      (1..1000).each do |i|
        @st.execute( i).fetch
      end
    end

    def prep_update_simple
      @dbh.execute( "INSERT INTO records ( id, s ) VALUES ( ?, ? )", 3, 'a string' )
      @st = @dbh.prepare( "SELECT * FROM records WHERE id = ?" )
    end
    def update_simple
      @dbh.execute( "UPDATE records SET s = ? WHERE id = ?", Time.now.to_f, 3 )
    end
  end
end; end
