class Todos::Index < BrowserAction
  include Auth::AllowGuests

  get "/todos" do
    page_number = params.get?(:page).try(&.to_i) || 1
    per_page = 20

    todos_query = TodoQuery.new.preload_user
    pages = Lucky::Paginator.new(
      page: page_number,
      per_page: per_page,
      item_count: todos_query.select_count,
      full_path: request.resource
    )

    todos = todos_query
      .offset(pages.offset)
      .limit(per_page)

    html IndexPage, todos: todos, pages: pages
  end
end
