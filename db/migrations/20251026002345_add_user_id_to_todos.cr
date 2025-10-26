class AddUserIdToTodos::V20251026002345 < Avram::Migrator::Migration::V1
  def migrate
    # Delete existing todos since we're adding a required user_id field
    execute "DELETE FROM todos;"

    alter table_for(Todo) do
      add_belongs_to user : User, on_delete: :cascade
    end
  end

  def rollback
    alter table_for(Todo) do
      remove_belongs_to :user
    end
  end
end
