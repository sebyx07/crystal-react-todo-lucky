class Todos::Create < BrowserAction
  post "/todos" do
    SaveTodo.create(params, user_id: current_user.id) do |operation, todo|
      if todo
        flash.success = "Todo created successfully"
        redirect to: Todos::Index
      else
        flash.failure = "Could not create todo"
        html NewPage, operation: operation
      end
    end
  end
end
