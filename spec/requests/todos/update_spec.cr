require "../../spec_helper"

describe Todos::Update do
  it "updates a todo with valid params" do
    user = UserFactory.create
    todo = TodoFactory.create &.title("Old title").completed(false).user_id(user.id)

    todo_params = {
      "title"     => "Updated title",
      "completed" => "true",
    }

    client = ApiClient.new
    response = client.exec(Todos::Update.with(todo.id), todo: todo_params, backdoor_user_id: user.id.to_s)

    response.status.should eq(HTTP::Status::FOUND)

    updated_todo = TodoQuery.find(todo.id)
    updated_todo.title.should eq "Updated title"
    updated_todo.completed.should be_true
  end

  it "updates todo even with empty title" do
    user = UserFactory.create
    todo = TodoFactory.create &.title("Valid title").user_id(user.id)

    todo_params = {
      "title"     => "Updated",
      "completed" => "true",
    }

    client = ApiClient.new
    response = client.exec(Todos::Update.with(todo.id), todo: todo_params, backdoor_user_id: user.id.to_s)

    response.status.should eq HTTP::Status::FOUND

    updated_todo = TodoQuery.find(todo.id)
    updated_todo.title.should eq "Updated"
    updated_todo.completed.should be_true
  end
end
