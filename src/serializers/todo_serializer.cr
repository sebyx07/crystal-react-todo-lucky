class TodoSerializer < BaseSerializer
  def initialize(@todo : Todo)
  end

  def render
    {
      id:         @todo.id,
      title:      @todo.title,
      completed:  @todo.completed,
      user_id:    @todo.user_id,
      created_at: @todo.created_at.to_s,
      updated_at: @todo.updated_at.to_s,
    }
  end
end
