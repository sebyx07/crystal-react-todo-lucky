class Todos::IndexPage < MainLayout
  needs todos : TodoQuery
  needs pages : Lucky::Paginator

  def content
    h1 "Todo List"

    link "New Todo", to: Todos::New, class: "btn btn-primary"

    ul class: "todo-list" do
      todos.each do |todo|
        li do
          link todo.title, to: Todos::Show.with(todo.id)
          span " - "
          span todo.completed? ? "✓ Completed" : "○ Pending"
          span " (by #{todo.user!.email})", class: "text-muted"
        end
      end
    end

    para do
      text "No todos yet!" if todos.size == 0
    end

    render_pagination
  end

  private def render_pagination
    div class: "pagination" do
      if pages.page > 1
        a "Previous", href: Todos::Index.path + "?page=#{pages.page - 1}", class: "btn"
      end

      span " Page #{pages.page} of #{pages.total} (#{pages.item_count} total items) "

      if pages.page < pages.total
        a "Next", href: Todos::Index.path + "?page=#{pages.page + 1}", class: "btn"
      end
    end
  end
end
