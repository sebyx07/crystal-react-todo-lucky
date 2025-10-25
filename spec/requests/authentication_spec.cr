require "../spec_helper"

describe "Authentication" do
  it "allows user sign up with valid credentials" do
    params = {
      email:                 "newuser@example.com",
      password:              "password123",
      password_confirmation: "password123",
    }

    client = ApiClient.new
    response = client.exec(SignUps::Create, user: params)

    response.status.should eq(HTTP::Status::FOUND)
    UserQuery.new.email("newuser@example.com").first?.should_not be_nil
  end

  it "prevents sign up with mismatched passwords" do
    params = {
      email:                 "newuser@example.com",
      password:              "password123",
      password_confirmation: "different",
    }

    client = ApiClient.new
    response = client.exec(SignUps::Create, user: params)

    response.status.should eq(HTTP::Status::OK)
    response.body.should contain("password")
    UserQuery.new.select_count.should eq 0
  end

  it "allows user sign in with valid credentials" do
    user = UserFactory.create &.email("test@example.com")

    params = {
      email:    "test@example.com",
      password: "password",
    }

    client = ApiClient.new
    response = client.exec(SignIns::Create, user: params)

    response.status.should eq(HTTP::Status::FOUND)
  end

  it "prevents sign in with invalid password" do
    user = UserFactory.create &.email("test@example.com")

    params = {
      email:    "test@example.com",
      password: "wrong-password",
    }

    client = ApiClient.new
    response = client.exec(SignIns::Create, user: params)

    response.status.should eq(HTTP::Status::OK)
    response.body.should contain("password")
  end

  it "allows user to sign out" do
    user = UserFactory.create

    client = ApiClient.new
    response = client.exec(SignIns::Delete)

    response.status.should eq(HTTP::Status::FOUND)
  end
end
