class Todos::Create < BrowserAction
  include Auth::AllowGuests

  post "/todos" do
    SaveTodo.create(params) do |operation, todo|
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
