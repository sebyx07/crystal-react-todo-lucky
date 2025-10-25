class Todos::EditPage < MainLayout
  needs operation : SaveTodo
  needs todo : Todo

  def content
    h1 "Edit Todo"

    render_form(operation, todo)

    link "Back to Todo", to: Todos::Show.with(todo.id)
    text " | "
    link "Back to List", to: Todos::Index
  end

  private def render_form(op, todo)
    form_for Todos::Update.with(todo.id) do
      label_for op.title
      text_input op.title, attrs: [:required]

      label_for op.completed, "Mark as completed"
      checkbox op.completed

      submit "Update Todo", class: "btn btn-primary"
    end
  end
end
