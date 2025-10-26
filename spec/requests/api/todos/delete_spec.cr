require "../../../spec_helper"

describe Api::Todos::Delete do
  it "deletes a todo for the authenticated user" do
    user = UserFactory.create
    todo = TodoFactory.create &.user_id(user.id)

    response = ApiClient.auth(user).exec(Api::Todos::Delete.with(todo.id))

    response.status_code.should eq(200)
    TodoQuery.new.id(todo.id).first?.should be_nil
  end

  it "prevents deleting other users' todos" do
    user = UserFactory.create
    other_user = UserFactory.create
    todo = TodoFactory.create &.user_id(other_user.id)

    response = ApiClient.auth(user).exec(Api::Todos::Delete.with(todo.id))

    response.status_code.should eq(404)
    TodoQuery.new.id(todo.id).first?.should_not be_nil
  end

  it "returns 404 for non-existent todo" do
    user = UserFactory.create

    response = ApiClient.auth(user).exec(Api::Todos::Delete.with(99999))

    response.status_code.should eq(404)
  end

  it "fails if not authenticated" do
    todo = TodoFactory.create

    response = ApiClient.exec(Api::Todos::Delete.with(todo.id))

    response.status_code.should eq(401)
  end
end
