## Note

The specs no longer pass becuase I require a user to be signed in to create, edit, delete, or like a dog. I also validate for the presence of a `owner_id` when a dog is created.  I also modified the seeds so that all dogs now have an owner.

app/controllers/application_controller.rb
```ruby
def ensure_loggin
  redirect_to dogs_url unless current_user
end
```

## Add pagination to index page, to display 5 dogs per page

I used the `will_paginate` gem to do this.

app/controllers/dogs_controller.rb
```ruby
@dogs = Dog.paginate(:page => params[:page], :per_page => 5).order(created_at: :asc)
```

app/views/dogs/index.html.erb
```ruby
<%= will_paginate @dogs, page_links: true %>
```

## Add the ability to for a user to input multiple dog images on an edit form or new dog form

app/views/dogs/_form.html.erb
```ruby
<%= simple_form_for(@dog, :html => { :multipart => true }) do |f| %>
  <%= f.input :name %>
  <%= f.input :description, as: :text %>
  <%= f.input :images, as: :file, input_html: { multiple: true } %>

  <% if @dog.images.any? %>
    <%= image_tag @dog.images.first %>
  <% end %>

  <%= f.button :submit %>
<% end %>
```

app/controllers/dogs_controller.rb
```ruby
def dog_params
  params.require(:dog).permit(:name, :description, images: [])
end
```

## Associate dogs with owners

I ran a migration to add a owner_id column to the dogs table.

app/models/dog.rb
```ruby
belongs_to :owner,
  class_name: :User
```

## Allow editing only by owner

I also only allow deletion by the owner.

app/controllers/dogs_controller.rb
```ruby
before_action :ensure_owner, only: [:edit, :update, :destroy]

def ensure_owner
  redirect_to @dog unless current_user && current_user.id == @dog.owner_id
end
```

app/views/dogs/show.html.erb
```ruby
<% if current_user && current_user.id == @dog.owner_id  %>
  <%= link_to "Edit #{@dog.name}'s Profile", edit_dog_path %>
  <br>
  <%= link_to "Delete #{@dog.name}'s Profile", dog_path, method: :delete, data: { confirm: 'Are you sure?' } %>
<% end %>
```

## Allow users to like other dogs (not their own)

I created a likes table that has columns for dog_id and user_id.

app/models/like.rb
```ruby
class Like < ApplicationRecord
  validates :user_id, uniqueness: { scope: :dog_id }
  validate :not_owner

  belongs_to :user

  belongs_to :dog

  private

    def not_owner
      errors.add(:user, "can't be dog's owner") if self.user_id == self.dog.owner_id
    end

end
```

app/controllers/likes_controller.rb
```ruby
class LikesController < ApplicationController
  before_action :set_like, only: :destroy
  before_action :ensure_loggin

  def create
    dog_id = params[:dog_id]
    @like = Like.new(dog_id: dog_id)
    @like.user_id = current_user.id

    if @like.save
      redirect_to dog_url(dog_id)
    else
      redirect_to dog_url(dog_id), notice: @like.errors.full_messages.first
    end
  end

  def destroy
    @like.destroy
    redirect_to dog_url(@like.dog_id)
  end

  private

    def set_like
      @like = Like.find(params[:id])
    end

end
```

app/views/dogs/show.html.erb
```ruby
<% if current_user && @dog.owner_id != current_user.id %>
  <% if @like %>
    <%= link_to "Unlike", like_url(@like), method: :delete %>
  <% else %>
    <%= link_to "Like", dog_likes_url(@dog), method: :post %>
  <% end %>
<% end %>
```

## Allow sorting the index page by number of likes in the last hour

app/controllers/dogs_controller.rb
```ruby
if params[:sort] == 'likes'
  @dogs = Dog.paginate(:page => params[:page], :per_page => 5).joins("LEFT OUTER JOIN likes ON likes.dog_id = dogs.id 
    AND likes.created_at >= datetime('now', '-1 Hour')").group(:id).order('COUNT(likes.id) DESC')
```

## Display the ad.jpg image after every 2 dogs in the index page

app/views/dogs/_thumbnail.html.erb
```ruby
<% if dog_counter.odd? %>
  <a href="#">
    <h2 class="ad-name">Ad</h2>
    <article>
      <%= image_tag image_url("ad.jpg"), class: "ad-photo", alt: "Photo of ad" %>
    </article>
  </a>
<% end %>
```
