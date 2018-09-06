class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_reader :name, :grade, :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
     sql  = <<-SQL
       CREATE TABLE IF NOT EXISTS students(
         id INTEGER PRIMARY KEY,
         name TEXT,
         grade TEXT
       )
       SQL
     DB[:conn].execute(sql)
   end

   def self.drop_table

     sql = "DROP TABLE students"

     DB[:conn].execute(sql)
   end

   def save
     sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
     SQL

     DB[:conn].execute( sql, self.name, self.grade)
     sql2 = <<-SQL
     SELECT id FROM students
     WHERE name = ? and grade = ?
     ORDER BY id DESC limit 1
     SQL

     @id = DB[:conn].execute(sql2, self.name, self.grade)[0][0]

     self 
   end

   def self.create(hash={})
     Student.new(hash[:name], hash[:grade]).save
   end

end
