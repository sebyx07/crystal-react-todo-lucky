class TodoFactory < Avram::Factory
  def initialize
    title "Sample Todo"
    completed false
    user_id UserFactory.create.id
  end
end
