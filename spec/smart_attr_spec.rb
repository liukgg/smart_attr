require 'spec_helper'

describe SmartAttr do

  describe 'Basic Usage(Without database)' do
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

    describe '#star_three!' do
      let(:movie) { Movie.new }

      it 'set value by name' do
        movie.star_three!
        expect(movie.star).to eq Movie.star_config[:three][:value]
      end
    end

    describe '#star_three?' do
      let(:movie) { Movie.new }

      it 'set value by name' do
        movie.star = 3
        expect(movie.star_three?).to eq true
      end
    end

    describe '#star_desc' do
      let(:movie) { Movie.new }

      it 'set value by name' do
        movie.star = 3
        expect(movie.star_desc).to eq 'three star'
      end
    end

  end

  describe 'With Database and ActiveRecord' do
    require 'yaml'

    before(:all) do
      db_config = YAML::load_file(File.dirname(__FILE__) + "/fixtures/active_record/database.yml")

      ActiveRecord::Base.configurations = db_config
      ActiveRecord::Base.establish_connection(:test)

      load File.dirname(__FILE__) + "/fixtures/active_record/schema.rb"
      load File.dirname(__FILE__) + "/fixtures/active_record/models.rb"
    end

    after(:all) do
      Song.delete_all
    end

    describe '#star_three?' do
      let(:song) { Song.create(star: 0) }

      it 'set value by name' do
        song.star = 3
        expect(song.star_three?).to eq true
      end

      it 'set value by name' do
        song.star = 3
        song.save

        expect(song.star_three?).to eq true
        expect(song.read_attribute :star).to eq 3
      end

      it 'set value by name' do
        song.star_name = :five
        song.save

        expect(song.star_three?).to eq false
        expect(song.star_five?).to eq true
        expect(song.read_attribute :star).to eq 5
      end
    end

  end

end
