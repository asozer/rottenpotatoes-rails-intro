class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all

    if (not session[:sort].nil? or not session[:ratings].nil?) and params[:ratings].nil? and params[:sort].nil? 
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end

    @all_ratings = ['G', 'PG', 'PG-13', 'R']

    param_rating = params[:ratings]
    session_rating = session[:ratings]
    @current_rating = nil

    param_sort = params[:sort]
    session_sort = session[:sort]
    @sort = nil

    if param_sort
      @sort = param_sort
    else 
      @sort = session_sort
    end

    if param_rating
      @current_rating = param_rating
    else
      @current_rating = session_rating
    end



    if not @current_rating == nil
      @movies = Movie.where(rating: @current_rating.keys).order(@sort)
    elsif not @sort == nil
      @movies = Movie.all.order(@sort)
    else
      @movies = Movie.all
    end
    
    session[:sort] = @sort
    session[:ratings] = @current_rating

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
