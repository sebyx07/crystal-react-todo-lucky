class SaveTodo < Todo::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/saving-records#perma-permitting-columns

  permit_columns title, completed

  before_save do
    validate_required title
    validate_size_of title, min: 1
    # Set default value for completed if not provided
    completed.value = completed.value || false
  end
end
