abstract class AppLayout
  include Lucky::HTMLPage

  # This will render the HTML boilerplate and include the React app
  abstract def page_title

  def render
    html_doctype

    html lang: "en" do
      head do
        utf8_charset
        title page_title
        css_link asset("css/app.css")
        meta name: "viewport", content: "width=device-width, initial-scale=1"
        csrf_meta_tags
      end

      body do
        # React app will mount here
        div id: "root"

        # Include the bundled React app
        js_link asset("js/app.js")
      end
    end
  end
end
