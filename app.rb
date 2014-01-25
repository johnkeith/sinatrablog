require "sinatra"
require "sinatra/activerecord"
require "./environments"
require "sinatra/flash"
require "sinatra/redirect_with_flash"

enable :sessions

class Post < ActiveRecord::Base
	validates :title, presence: true, length: {minimum: 5}
	validates :body, presence: true
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def title
    if @title
      "#{@title}"
    else
      "Welcome."
    end
  end
end

#show all posts
get "/" do
	@posts = Post.order("created_at DESC")
	@title = "Welcome!"
	erb :"posts/index"
end

#create new post
get "/posts/create" do
	@title = "Create Post"
	@post = Post.new
	erb :"posts/create"
end

post "/posts" do
	@post = Post.new(params[:post])
	if @post.save
		redirect "posts/#{@post.id}", :notice => "Congrats, your entry has been posted!"
	else
		redirect "posts/create", :notice => "Something went wrong - please try again!"
	end
end

#view a post
get "/posts/:id" do
	@post = Post.find(params[:id])
	@title = @post.title
	erb :"posts/view"
end

#edit post
get "/posts/:id/edit" do
	@post = Post.find(params[:id])
	@title = "Edit Form"
	erb :"posts/edit"
end

put "/posts/:id" do
	@post = Post.find(params[:id])
	@post.update(params[:post])
	redirect "/posts/#{@post.id}"
end
