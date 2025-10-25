class Todos::Update < BrowserAction
  include Auth::AllowGuests

  patch "/todos/:id" do
    todo = TodoQuery.find(id)
    SaveTodo.update(todo, params) do |operation, updated_todo|
      if updated_todo
        flash.success = "Todo updated successfully"
        redirect to: Todos::Show.with(todo.id)
      else
        flash.failure = "Could not update todo"
        html EditPage, operation: operation, todo: todo
      end
    end
  end
end
