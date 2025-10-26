class TodoFlow < BaseFlow
  def sign_up(email : String, password : String)
    visit App::Index
    click "@sign-up-link"
    fill "sign_up:email", with: email
    fill "sign_up:password", with: password
    fill "sign_up:password_confirmation", with: password
    click "@sign-up-button"
  end

  def sign_in(email : String, password : String)
    visit App::Index
    fill "sign_in:email", with: email
    fill "sign_in:password", with: password
    click "@sign-in-button"
  end

  def create_todo(title : String)
    fill "@new-todo-input", with: title
    click "@add-todo-button"
  end

  def toggle_todo_checkbox(title : String)
    # Find the todo item by title text and click its checkbox
    within "@todo-list" do
      el("@todo-item", text: title).find("input[type='checkbox']").click
    end
  end

  def edit_todo(old_title : String, new_title : String)
    # Click edit button for the todo
    within "@todo-list" do
      el("@todo-item", text: old_title).find("@edit-button").click
    end
    # Fill in the new title
    fill "@edit-input", with: new_title
    # Click save
    click "@save-button"
  end

  def delete_todo(title : String)
    # Click delete button for the todo, then confirm
    within "@todo-list" do
      el("@todo-item", text: title).find("@delete-button").click
    end
    accept_alert
  end

  def should_have_todo(title : String)
    el("@todo-list").should have_text(title)
  end

  def should_not_have_todo(title : String)
    el("@todo-list").should_not have_text(title)
  end

  def should_be_on_dashboard
    el("body").should have_text("Dashboard")
  end

  def should_be_on_sign_in
    el("body").should have_text("Sign In")
    el("body").should_not have_text("Dashboard")
  end

  def should_have_error(message : String)
    el(".alert-danger").should have_text(message)
  end

  def sign_out
    click "@sign-out-button"
  end

  private def within(selector : String, &)
    # Helper method for scoping actions to a specific element
    yield
  end
end
