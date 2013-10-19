SimpleRoles.configure do
  valid_roles :admin, :editor
  strategy :one # Default is :one
end