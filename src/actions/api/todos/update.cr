class Api::Todos::Update < ApiAction
  patch "/api/todos/:id" do
    todo = TodoQuery.new.id(id).user_id(current_user.id).first?

    if todo
      SaveTodo.update(todo, params) do |operation, updated_todo|
        if updated_todo && operation.valid?
          json TodoSerializer.new(updated_todo).render
        else
          json({errors: operation.errors}, status: 422)
        end
      end
    else
      json({error: "Todo not found"}, status: 404)
    end
  end
end
