class SaveTodo < Todo::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/saving-records#perma-permitting-columns

  permit_columns title, completed

  before_save do
    # Validate user_id is present
    validate_required user_id
    # Trim title and validate it's not empty
    title.value = title.value.to_s.strip
    validate_required title
    # Set default value for completed if not provided
    completed.value = completed.value || false
  end
end
