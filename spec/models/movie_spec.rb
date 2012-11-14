require 'spec_helper'

describe Movie do
  describe 'searching for movies with same directors' do
    it 'should call Movie with director' do
      Movie.should_receive(:find_by_same_director).with('Aladdin')
      Movie.find_by_same_director('Aladdin')
    end
  end
end