class Todos::Edit < BrowserAction
  get "/todos/:id/edit" do
    todo = TodoQuery.new.user_id(current_user.id).find(id)
    operation = SaveTodo.new(todo)
    html EditPage, operation: operation, todo: todo
  end
end
