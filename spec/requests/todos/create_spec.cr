require "../../spec_helper"

describe Todos::Create do
  it "creates a todo with valid params" do
    user = UserFactory.create
    todo_params = {
      "title"     => "New todo",
      "completed" => "false",
    }

    client = ApiClient.new
    response = client.exec(Todos::Create, todo: todo_params, backdoor_user_id: user.id.to_s)

    response.status.should eq(HTTP::Status::FOUND)
    TodoQuery.new.select_count.should eq 1
  end

  it "fails with invalid params" do
    user = UserFactory.create
    todo_params = {
      "title"     => "",
      "completed" => "false",
    }

    client = ApiClient.new
    response = client.exec(Todos::Create, todo: todo_params, backdoor_user_id: user.id.to_s)

    response.status.should eq HTTP::Status::OK
    response.body.should contain("title")
  end
end
