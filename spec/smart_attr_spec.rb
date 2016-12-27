require 'spec_helper'

describe SmartAttr do

  before(:each) do
    load File.dirname(__FILE__) + "/fixtures/models.rb"
  end

  it 'has a version number' do
    expect(SmartAttr::VERSION).not_to be nil
  end

  describe 'define useful class methods correctly' do

    subject { Movie }

    it { should respond_to(:smart_attr) }
    it { should respond_to(:star_config) }
    it { should respond_to(:star_array) }

  end

  describe 'define useful instance methods correctly' do
    subject { Movie.new }

    it { should respond_to(:star_config) }
    it { should respond_to(:star_desc) }
    it { should respond_to(:star_name) }
    it { should respond_to(:"star_name=") }
    it { should respond_to(:"star_three!") }
    it { should respond_to(:"star_three?") }
  end

  describe '.star_config_hash' do
    it 'correct hash' do
      hash = {
        one:    { value: 1, desc: 'one star' },
        two:    { value: 2, desc: 'two star' },
        three:  { value: 3, desc: 'three star' },
        four:   { value: 4, desc: 'four star' },
        five:   { value: 5, desc: 'five star' }
      }

      expect(Movie.star_config_hash).to eq hash
    end
  end

  describe '#star_name=' do
    let(:movie) { Movie.new }

    it 'set value by name' do
      movie.star_name = :one
      expect(movie.star).to eq Movie.star_config[:one][:value]
    end
  end

end
