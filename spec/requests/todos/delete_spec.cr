require "../../spec_helper"

describe Todos::Delete do
  it "deletes a todo" do
    user = UserFactory.create
    todo = TodoFactory.create &.title("To be deleted").user_id(user.id)

    client = ApiClient.new
    response = client.exec(Todos::Delete.with(todo.id), backdoor_user_id: user.id.to_s)

    response.status.should eq(HTTP::Status::FOUND)
    TodoQuery.new.select_count.should eq 0
  end
end
