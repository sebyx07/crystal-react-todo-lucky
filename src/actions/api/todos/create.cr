class Api::Todos::Create < ApiAction
  post "/api/todos" do
    SaveTodo.create(params, user_id: current_user.id) do |operation, todo|
      if todo
        json TodoSerializer.new(todo).render, status: 201
      else
        json({errors: operation.errors}, status: 422)
      end
    end
  end
end
