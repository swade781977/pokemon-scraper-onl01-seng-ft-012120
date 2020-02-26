class Pokemon
  attr_accessor :name, :type
  attr_reader :id 
  
  @all = []
  
  def initialize(id = nil, name, type, db)
    @id = id
    @name = name
    @type = type
  end
  
  def save
    sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?, ?)
    SQL
    
    DB[:conn].execute(sql, self.name, self.type)
    
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
  end
  
  def self.new_from_db
    new_pokemon = self.new(row[0], row[1], row[2])
    new_pokemon
  end
  
  def self.find(id)
    sql = <<-SQL
      SELECT *
      FROM pokemon
      WHERE id = ?
      LIMIT 1
    SQL
    
    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  
end
