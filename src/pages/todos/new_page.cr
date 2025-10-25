class Todos::NewPage < MainLayout
  needs operation : SaveTodo

  def content
    h1 "New Todo"

    render_form(operation)

    link "Back to List", to: Todos::Index
  end

  private def render_form(op)
    form_for Todos::Create do
      label_for op.title
      text_input op.title, attrs: [:required]

      label_for op.completed, "Mark as completed"
      checkbox op.completed

      submit "Create Todo", class: "btn btn-primary"
    end
  end
end
