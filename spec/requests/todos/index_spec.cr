require "../../spec_helper"

describe Todos::Index do
  it "shows all todos" do
    todo1 = TodoFactory.create &.title("Buy groceries").completed(false)
    todo2 = TodoFactory.create &.title("Finish project").completed(true)

    client = ApiClient.new
    response = client.exec(Todos::Index)

    response.status.should eq(HTTP::Status::OK)
    response.body.should contain("Buy groceries")
    response.body.should contain("Finish project")
  end

  it "shows empty state when no todos" do
    client = ApiClient.new
    response = client.exec(Todos::Index)

    response.status.should eq(HTTP::Status::OK)
    response.body.should contain("No todos yet!")
  end
end
