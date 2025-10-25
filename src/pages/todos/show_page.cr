class Todos::ShowPage < MainLayout
  needs todo : Todo

  def content
    h1 "Todo Details"

    div class: "todo-details" do
      h2 todo.title
      para "Status: #{todo.completed? ? "Completed" : "Pending"}"
      para "Created: #{todo.created_at}"
    end

    div class: "actions" do
      link "Edit", to: Todos::Edit.with(todo.id), class: "btn btn-warning"
      link "Delete", to: Todos::Delete.with(todo.id), class: "btn btn-danger", flow_id: "delete-todo"
      link "Back to List", to: Todos::Index, class: "btn btn-secondary"
    end
  end
end
