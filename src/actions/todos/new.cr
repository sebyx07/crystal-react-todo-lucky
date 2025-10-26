class Todos::New < BrowserAction
  get "/todos/new" do
    operation = SaveTodo.new
    html NewPage, operation: operation
  end
end
