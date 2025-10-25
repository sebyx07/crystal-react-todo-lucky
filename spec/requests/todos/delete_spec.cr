require "../../spec_helper"

describe Todos::Delete do
  it "deletes a todo" do
    todo = TodoFactory.create &.title("To be deleted")

    client = ApiClient.new
    response = client.exec(Todos::Delete.with(todo.id))

    response.status.should eq(HTTP::Status::FOUND)
    TodoQuery.new.select_count.should eq 0
  end
end
