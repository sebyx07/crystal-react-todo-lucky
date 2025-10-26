class Todos::Show < BrowserAction
  get "/todos/:id" do
    todo = TodoQuery.new.user_id(current_user.id).find(id)
    html ShowPage, todo: todo
  end
end
