require "../spec_helper"

# NOTE: LuckyFlow requires a browser (Chrome/Chromium) to run
# Docker container needs browser installed for these tests
# For now, use frontend unit tests (Vitest) and API request specs
describe "Todo management flow", tags: "flow" do
  pending "allows user to sign in and manage todos" do
    user = UserFactory.create &.email("todo-user@example.com")
    flow = TodoFlow.new

    # Sign in
    flow.sign_in("todo-user@example.com", "password")
    flow.should_be_on_dashboard

    # Create a todo
    flow.create_todo("Buy groceries")
    flow.should_have_todo("Buy groceries")

    # Create another todo
    flow.create_todo("Finish project")
    flow.should_have_todo("Finish project")

    # Sign out
    flow.sign_out
    flow.should_be_on_sign_in
  end

  pending "allows user to sign up and access dashboard" do
    flow = TodoFlow.new
    email = "new-user-#{Time.utc.to_unix}@example.com"

    # Sign up
    flow.sign_up(email, "password123")
    flow.should_be_on_dashboard

    # Should be able to create a todo
    flow.create_todo("First todo")
    flow.should_have_todo("First todo")
  end
end
