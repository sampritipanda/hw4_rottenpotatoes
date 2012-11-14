require 'spec_helper'

describe MoviesController do
  describe 'add director to movie' do
    before :each do
      @m = mock(Movie, :title => 'Aladdin', :director => 'Ernest Hemingway', :id => '1')
      Movie.stub!(:find).with('1').and_return(@m)
    end
    it 'should call update attributes and redirect to show page for the movie' do
      @m.stub!(:update_attributes!).and_return(true)
      put :update, :id => '1', :title => @m
      response.should redirect_to movie_path(@m)
    end
  end
  
  describe 'happy path for searching movies with same director' do
    before :each do
      @m = mock(Movie, :title => 'Aladdin', :director => 'd', :id => '1')
      Movie.stub!(:find).with('1').and_return(@m)
    end
    
    it 'should route to same movies path for Similar Movies' do
      { :post => movie_same_path(1) }.
        should route_to(:controller => 'movies', :action => 'same', :movie_id => '1')
    end
        
    it 'should call the model method that finds movies with same directors' do
      results = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:find_by_same_director).with('d').and_return(results)
      get :same, :movie_id => '1'
    end
    
    it 'should render the same view and show the results with same director' do
      Movie.stub!(:find_by_same_director).with('d').and_return(@m)
      get :same, :movie_id => '1'
      response.should render_template('same')
      assigns(:movies) == @m
    end
  end
  
  describe 'sad path for searching movies with same director' do
    before :each do
      m = mock(Movie, :title => 'Aladdin', :director => nil, :id => '1')
      Movie.stub!(:find).with('1').and_return(m)
    end
    
    it 'should route to same movies path for Similar Movies' do
      { :post => movie_same_path(1) }.
        should route_to(:controller => 'movies', :action => 'same', :movie_id => '1')
    end
    
    it 'should render the index page and write the flash notice if similar movies is called with nil director' do
      get :same, :movie_id => '1'
      response.should redirect_to(movies_path)
      flash[:notice].should_not be_blank
    end
  end
end