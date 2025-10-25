class Todos::Index < BrowserAction
  include Auth::AllowGuests

  get "/todos" do
    todos = TodoQuery.new
    html IndexPage, todos: todos
  end
end
