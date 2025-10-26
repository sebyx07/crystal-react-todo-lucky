class Todo < BaseModel
  table do
    column title : String
    column completed : Bool
    belongs_to user : User
  end
end
