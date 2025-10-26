class Api::Todos::Show < ApiAction
  get "/api/todos/:id" do
    todo = TodoQuery.new.id(id).user_id(current_user.id).first?

    if todo
      json TodoSerializer.new(todo).render
    else
      json({error: "Todo not found"}, status: 404)
    end
  end
end
