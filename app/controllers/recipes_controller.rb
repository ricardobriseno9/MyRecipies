class RecipesController < ApplicationController
    before_action :set_recipe, only: [:edit,:update,:show,:like]
    before_action :require_user, except: [:show, :index]
    before_action :require_same_user, only: [:edit,:update]
    
    def index 
        @recipes = Recipe.paginate(page:params[:page], per_page: 4)

    end
    
    def show 

    end
    
    def new 
        @recipe = Recipe.new
    end
    
    def create 
        @recipe = Recipe.new(recipe_params)
        @recipe.chef = current_user
        
        if @recipe.save
          flash[:success] = "Your recipe was created succesfully!"
          redirect_to chef_path(@chef)
        else 
            render :new
        end
    end
    
    def edit 
        
    end
    
    def update 
        if @recipe.update(recipe_params) 
            #isdjfisd
            flash[:success] = "Your recipe was updated succesfully!"
            redirect_to recipe_path(@recipe)
        else 
            render :edit
        end
    end
    
 def like 
      like = Like.create(likes: params[:like], chef: current_user, recipe: @recipe)
     if like.valid?
        flash[:success] = "your selection was successful"
        redirect_to :back
     else
        flash[:danger] = "You can only like/dislike a recipe once"
        redirect_to :back
     end
end
         
         private 
    
    def recipe_params
        params.require(:recipe).permit(:name, :summary, :description, :picture)
    end
    
    def set_recipe 
        @recipe = Recipe.find(params[:id])  
    end
    
    def require_same_user
        if current_user != @recipe.chef 
            flash[:danger] = "you can only edit your own recipes"
            redirect_to root_path
        end
    end
end