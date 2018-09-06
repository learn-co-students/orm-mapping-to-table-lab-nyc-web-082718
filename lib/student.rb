class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name,:grade
  attr_reader :id

  def initialize(name,grade,id=nil)
    @name=name
    @grade=grade
    @id=id
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
    sql = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql,self.name,self.grade)

    sql = <<-SQL
    SELECT id FROM students
    WHERE name = ? and grade = ?
    ORDER BY id DESC LIMIT 1
    SQL

    @id = DB[:conn].execute(sql, self.name, self.grade)[0][0]
    self
  end

  def self.create(attrs={})
    new_student = self.new(attrs[:name],attrs[:grade])
    new_student.save
  end

end
