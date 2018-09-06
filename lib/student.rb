require 'pry'
class Student
  attr_accessor :name, :grade

  @@all = []

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
    @@all << self
  end

  def self.create_table
    sql  = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT)
        SQL
      DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students(name, grade) VALUES
      (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT * FROM students ORDER BY id DESC LIMIT 1" )[0][0]
  
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def self.create(hash)
    name = hash[:name]
    grade = hash[:grade]
    new_stu = Student.new(name, grade)
    new_stu.save
  end


end
