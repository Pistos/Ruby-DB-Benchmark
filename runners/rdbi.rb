module RDBB; module Runner
  class RDBI
    def initialize
      @dbh = ::RDBI.connect( :PostgreSQL, database: 'rdbb', username: 'rdbb', password: 'rdbb' )
    end

    def insert_simple
      @dbh.execute( "INSERT INTO records ( s ) VALUES ( ? )", 'a string' )
    end

    def prep_select_simple
      @st = @dbh.prepare( "SELECT * FROM records WHERE id = ?" )
    end
    def select_simple
      @st.execute( 1 ).fetch
    end
  end
end; end
