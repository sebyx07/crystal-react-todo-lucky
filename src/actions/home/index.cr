class Home::Index < BrowserAction
  include Auth::AllowGuests

  get "/" do
    redirect Todos::Index
  end
end
