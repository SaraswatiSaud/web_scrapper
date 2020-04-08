json.extract! app, :id, :name, :description, :email, :help_link, :categories, :created_at, :updated_at
json.url app_url(app, format: :json)
