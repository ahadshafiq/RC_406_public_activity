class RecipesController < ApplicationController
  before_filter :require_login, except: [:index, :show]

  def index
    @recipes = Recipe.find_with_reputation(:votes, :all, order: "votes desc")
  end

  def show
    @recipe = Recipe.find(params[:id])
    @comment = Comment.new
  end

  def new
    @recipe = current_user.recipes.build
  end

  def create
    @recipe = current_user.recipes.build(params[:recipe])
    if @recipe.save
      redirect_to @recipe, notice: "Recipe was created."
    else
      render :new
    end
  end

  def edit
    @recipe = current_user.recipes.find(params[:id])
  end

  def update
    @recipe = current_user.recipes.find(params[:id])
    if @recipe.update_attributes(params[:recipe])
      redirect_to @recipe, notice: "Recipe was updated."
    else
      render :edit
    end
  end

  def destroy
    @recipe = current_user.recipes.find(params[:id])
    @recipe.destroy
    redirect_to recipes_url, notice: "Recipe was destroyed."
  end

  def vote
    value = params[:type] == "up" ? 1 : -1
    @recipe = Recipe.find(params[:id])
    @recipe.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back, notice: "Thank you for voting"
  end
end
