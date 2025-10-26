require "../../../spec_helper"

describe Api::Todos::Index do
  it "returns todos for the authenticated user" do
    user = UserFactory.create
    todo1 = TodoFactory.create &.user_id(user.id).title("First todo")
    todo2 = TodoFactory.create &.user_id(user.id).title("Second todo")
    other_user_todo = TodoFactory.create

    response = ApiClient.auth(user).exec(Api::Todos::Index)

    response.status_code.should eq(200)
    body = JSON.parse(response.body)

    todos = body["todos"].as_a
    todos.size.should eq(2)
    todos.any? { |t| t["id"] == todo1.id }.should be_true
    todos.any? { |t| t["id"] == todo2.id }.should be_true
    todos.any? { |t| t["id"] == other_user_todo.id }.should be_false
  end

  it "returns paginated results" do
    user = UserFactory.create
    25.times { TodoFactory.create &.user_id(user.id) }

    response = ApiClient.auth(user).exec(Api::Todos::Index, page: "1", per_page: "10")

    response.status_code.should eq(200)
    body = JSON.parse(response.body)

    body["todos"].as_a.size.should eq(10)
    body["pagination"]["total_items"].should eq(25)
    body["pagination"]["total_pages"].should eq(3)
  end

  it "fails if not authenticated" do
    response = ApiClient.exec(Api::Todos::Index)

    response.status_code.should eq(401)
  end
end
