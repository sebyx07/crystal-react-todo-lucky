class Todos::Delete < BrowserAction
  include Auth::AllowGuests

  delete "/todos/:id" do
    todo = TodoQuery.find(id)
    DeleteTodo.delete(todo) do |operation, deleted_todo|
      if deleted_todo
        flash.success = "Todo deleted successfully"
        redirect to: Todos::Index
      else
        flash.failure = "Could not delete todo"
        redirect_back fallback: Todos::Index
      end
    end
  end
end
