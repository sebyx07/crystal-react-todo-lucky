require "../../../spec_helper"

describe Api::Todos::Create do
  it "creates a todo for the authenticated user" do
    user = UserFactory.create

    response = ApiClient.auth(user).exec(Api::Todos::Create, todo: {title: "New todo"})

    response.status_code.should eq(201)
    body = JSON.parse(response.body)

    body["title"].should eq("New todo")
    body["completed"].should eq(false)
    body["user_id"].should eq(user.id)
  end

  it "validates title presence" do
    user = UserFactory.create

    response = ApiClient.auth(user).exec(Api::Todos::Create, todo: {title: ""})

    response.status_code.should eq(422)
    body = JSON.parse(response.body)
    body["errors"].should_not be_nil
  end

  it "fails if not authenticated" do
    response = ApiClient.exec(Api::Todos::Create, todo: {title: "New todo"})

    response.status_code.should eq(401)
  end
end
