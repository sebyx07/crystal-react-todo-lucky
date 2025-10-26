class Api::Todos::Index < ApiAction
  get "/api/todos" do
    page_number = params.get?(:page).try(&.to_i) || 1
    per_page = params.get?(:per_page).try(&.to_i) || 20

    todos_query = TodoQuery.new.user_id(current_user.id)

    paginator = Lucky::Paginator.new(
      page: page_number,
      per_page: per_page,
      item_count: todos_query.select_count,
      full_path: request.resource
    )

    todos = todos_query
      .offset(paginator.offset)
      .limit(per_page)
      .results

    json({
      todos:      todos.map { |todo| TodoSerializer.new(todo).render },
      pagination: PaginationSerializer.new(paginator).render,
    })
  end
end
