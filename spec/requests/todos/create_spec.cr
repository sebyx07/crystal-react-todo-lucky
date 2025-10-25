require "../../spec_helper"

describe Todos::Create do
  it "creates a todo with valid params" do
    params = {
      "title"     => "New todo",
      "completed" => "false",
    }

    client = ApiClient.new
    response = client.exec(Todos::Create, todo: params)

    response.status.should eq(HTTP::Status::FOUND)
    TodoQuery.new.select_count.should eq 1
  end

  it "fails with invalid params" do
    params = {
      "title"     => "",
      "completed" => "false",
    }

    client = ApiClient.new
    response = client.exec(Todos::Create, todo: params)

    response.status.should eq HTTP::Status::OK
    response.body.should contain("title")
  end
end
