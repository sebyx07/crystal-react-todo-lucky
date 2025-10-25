class Todos::Show < BrowserAction
  include Auth::AllowGuests

  get "/todos/:id" do
    todo = TodoQuery.find(id)
    html ShowPage, todo: todo
  end
end
