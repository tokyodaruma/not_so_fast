json.array! @notifications do |notification|
  json.extract! notification, :id, :read, :accessed_at, :description
end
