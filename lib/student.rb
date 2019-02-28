require 'pry'
class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_reader  :name, :grade, :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    query = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
    SQL
    DB[:conn].execute(query)
  end

  def self.drop_table
    DB[:conn].execute('DROP TABLE IF EXISTS students;')
  end

  def self.create(name:, grade:)
    student = self.new(name, grade)
    student.save
    student
  end

  def save
    query = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?);
    SQL
    DB[:conn].execute(query, self.name, self.grade)
    @id = DB[:conn].execute("SELECT * FROM students").flatten.first
  end
end
