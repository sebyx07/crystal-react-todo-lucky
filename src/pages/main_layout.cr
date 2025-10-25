abstract class MainLayout
  include Lucky::HTMLPage

  # 'needs current_user : User?' makes it so that the current_user
  # can be nil for pages that allow guests
  needs current_user : User?

  abstract def content
  abstract def page_title

  # MainLayout defines a default 'page_title'.
  #
  # Add a 'page_title' method to your indivual pages to customize each page's
  # title.
  #
  # Or, if you want to require every page to set a title, change the
  # 'page_title' method in this layout to:
  #
  #    abstract def page_title : String
  #
  # This will force pages to define their own 'page_title' method.
  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body do
        mount Shared::FlashMessages, context.flash
        render_signed_in_user
        content
      end
    end
  end

  private def render_signed_in_user
    if user = current_user
      text user.email
      text " - "
      link "Sign out", to: SignIns::Delete, flow_id: "sign-out-button"
    else
      link "Sign in", to: SignIns::New
      text " | "
      link "Sign up", to: SignUps::New
    end
  end
end
