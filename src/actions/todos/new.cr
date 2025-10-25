class Todos::New < BrowserAction
  include Auth::AllowGuests

  get "/todos/new" do
    operation = SaveTodo.new
    html NewPage, operation: operation
  end
end
