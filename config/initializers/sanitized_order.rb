class ActiveRecord::Relation
    def sanitized_order( column, direction = nil )
      direction ||= "ASC"
  
      raise "Column value of #{column} not permitted."       unless self.klass.column_names.include?( column.to_s ) 
      raise "Direction value of #{direction} not permitted." unless [ "ASC", "DESC" ].include?( direction.upcase ) 
  
      self.order( "#{column} #{direction}" )
    end  
  end
  