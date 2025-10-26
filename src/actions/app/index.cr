class App::Index < BrowserAction
  include Auth::AllowGuests

  # This catches all routes and serves the React app
  # React Router will handle the actual routing
  get "/*" do
    html IndexPage
  end
end
