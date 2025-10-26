require "../../../spec_helper"

describe Api::Todos::Show do
  it "returns a todo for the authenticated user" do
    user = UserFactory.create
    todo = TodoFactory.create &.user_id(user.id).title("My todo")

    response = ApiClient.auth(user).exec(Api::Todos::Show.with(todo.id))

    response.status_code.should eq(200)
    body = JSON.parse(response.body)

    body["id"].should eq(todo.id)
    body["title"].should eq("My todo")
  end

  it "prevents viewing other users' todos" do
    user = UserFactory.create
    other_user = UserFactory.create
    todo = TodoFactory.create &.user_id(other_user.id)

    response = ApiClient.auth(user).exec(Api::Todos::Show.with(todo.id))

    response.status_code.should eq(404)
  end

  it "returns 404 for non-existent todo" do
    user = UserFactory.create

    response = ApiClient.auth(user).exec(Api::Todos::Show.with(99999))

    response.status_code.should eq(404)
  end

  it "fails if not authenticated" do
    todo = TodoFactory.create

    response = ApiClient.exec(Api::Todos::Show.with(todo.id))

    response.status_code.should eq(401)
  end
end
