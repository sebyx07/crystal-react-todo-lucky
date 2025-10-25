class Todos::IndexPage < MainLayout
  needs todos : TodoQuery

  def content
    h1 "Todo List"

    link "New Todo", to: Todos::New, class: "btn btn-primary"

    ul class: "todo-list" do
      todos.each do |todo|
        li do
          link todo.title, to: Todos::Show.with(todo.id)
          span " - "
          span todo.completed? ? "✓ Completed" : "○ Pending"
        end
      end
    end

    para do
      text "No todos yet!" if todos.size == 0
    end
  end
end
