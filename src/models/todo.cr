class Todo < BaseModel
  table do
    column title : String
    column completed : Bool
  end
end
