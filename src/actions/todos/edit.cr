class Todos::Edit < BrowserAction
  include Auth::AllowGuests

  get "/todos/:id/edit" do
    todo = TodoQuery.find(id)
    operation = SaveTodo.new(todo)
    html EditPage, operation: operation, todo: todo
  end
end
