require 'spec_helper'

describe SmartAttr do

  before(:each) do
    load File.dirname(__FILE__) + "/fixtures/models.rb"
  end

  it 'has a version number' do
    expect(SmartAttr::VERSION).not_to be nil
  end

  describe 'define some class methods' do

    subject { Book }

    it { should respond_to(:clever_column) }
    it { should respond_to(:star_config) }
    it { should respond_to(:star_array) }

  end

  describe 'define some instance methods' do
    subject { Book.new }

    it { should respond_to(:star_config) }
    it { should respond_to(:star_desc) }
    it { should respond_to(:star_name) }
    it { should respond_to(:"star_name=") }
    it { should respond_to(:"star_three!") }
    it { should respond_to(:"star_three?") }
  end

end
