class VariantsQuery < Queryko::Base
  feature :created_at, :min
  feature :created_at, :max
  feature :updated_at, :min
  feature :updated_at, :max

  feature :title, :search, as: :title
end
