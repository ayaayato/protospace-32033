class PrototypesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :move_to_index, except: [:index, :show, :search]
  before_action :exile_to_index, only: [:edit]

def index
  @prototypes = Prototype.includes(:user)
end

def new
  @prototype = Prototype.new
end

def create
  @prototype_c = Prototype.new(proto_params)
    if @prototype_c.save
      redirect_to root_path
    else
     render :new
    end
end

def show
  @prototype = Prototype.find(params[:id])
  @comment = Comment.new
  @comments = @prototype.comments.includes(:user)

end

def edit
  @prototype = Prototype.find(params[:id])
end

def update
  prototype = Prototype.find(params[:id])
  prototype.update(proto_params)
  if prototype.save
    redirect_to prototype_path(prototype.id)
  else
   render :edit
  end
end

def destroy
  prototype = Prototype.find(params[:id])
  prototype.destroy
  if prototype.destroy
    redirect_to root_path
  end

end


private
def proto_params
  params.require(:prototype).permit(:image, :catch_copy, :title, :concept).merge(user_id: current_user.id)
end

def move_to_index
  unless user_signed_in?
    redirect_to action: :index
  end
end

def exile_to_index
  @prototype = Prototype.find_by(id:params[:id])
   if @prototype.user_id != current_user.id
     redirect_to action: :index
  end
end


end
