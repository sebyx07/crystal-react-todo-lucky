class Api::Todos::Delete < ApiAction
  delete "/api/todos/:id" do
    todo = TodoQuery.new.id(id).user_id(current_user.id).first?

    if todo
      DeleteTodo.delete(todo) do |operation, deleted_todo|
        if deleted_todo
          json({message: "Todo deleted successfully"})
        else
          json({errors: operation.errors}, status: 422)
        end
      end
    else
      json({error: "Todo not found"}, status: 404)
    end
  end
end
