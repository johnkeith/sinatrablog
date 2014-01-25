configure :development do
  set :database, "sqlite:///dev.db"
  set :show_exceptions, true
end

configure :production do
	db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

	ActiveRecord::Base.establish_connection(
		:adaptor => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
		:host => db.host,
		:username => db.user,
		:password => db.password,
		:databse => db.path[1..-1],
		:encoding => 'utf8'
		)
end
