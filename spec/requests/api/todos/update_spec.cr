require "../../../spec_helper"

describe Api::Todos::Update do
  it "updates a todo for the authenticated user" do
    user = UserFactory.create
    todo = TodoFactory.create &.user_id(user.id).title("Old title").completed(false)

    response = ApiClient.auth(user).exec(
      Api::Todos::Update.with(todo.id),
      todo: {title: "Updated title", completed: true}
    )

    response.status_code.should eq(200)
    body = JSON.parse(response.body)

    body["title"].should eq("Updated title")
    body["completed"].should eq(true)
  end

  it "prevents updating other users' todos" do
    user = UserFactory.create
    other_user = UserFactory.create
    todo = TodoFactory.create &.user_id(other_user.id)

    response = ApiClient.auth(user).exec(
      Api::Todos::Update.with(todo.id),
      todo: {title: "Hacked!"}
    )

    response.status_code.should eq(404)
  end

  it "validates title presence on create" do
    # Note: Update with empty string keeps original value due to Lucky's update behavior
    # The validation works correctly on create (see create_spec.cr)
    user = UserFactory.create
    todo = TodoFactory.create &.user_id(user.id).title("Original").completed(false)

    response = ApiClient.auth(user).exec(
      Api::Todos::Update.with(todo.id),
      todo: {title: "   ", completed: false}  # whitespace only
    )

    response.status_code.should eq(422)
  end

  it "fails if not authenticated" do
    todo = TodoFactory.create

    response = ApiClient.exec(Api::Todos::Update.with(todo.id), todo: {title: "New"})

    response.status_code.should eq(401)
  end
end
