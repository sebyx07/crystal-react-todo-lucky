require "../../spec_helper"

describe Todos::Update do
  it "updates a todo with valid params" do
    todo = TodoFactory.create &.title("Old title").completed(false)

    params = {
      "title"     => "Updated title",
      "completed" => "true",
    }

    client = ApiClient.new
    response = client.exec(Todos::Update.with(todo.id), todo: params)

    response.status.should eq(HTTP::Status::FOUND)

    updated_todo = TodoQuery.find(todo.id)
    updated_todo.title.should eq "Updated title"
    updated_todo.completed.should be_true
  end

  it "updates todo even with empty title" do
    todo = TodoFactory.create &.title("Valid title")

    params = {
      "title"     => "Updated",
      "completed" => "true",
    }

    client = ApiClient.new
    response = client.exec(Todos::Update.with(todo.id), todo: params)

    response.status.should eq HTTP::Status::FOUND

    updated_todo = TodoQuery.find(todo.id)
    updated_todo.title.should eq "Updated"
    updated_todo.completed.should be_true
  end
end
