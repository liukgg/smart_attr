# encoding: utf-8
class Book

  include Mongoid::Document

  include SmartAttr::Base

  field :star, type: Integer, default: nil

  smart_attr :star, config: {
    one:    { value: 1, desc: 'one star' },
    two:    { value: 2, desc: 'two star' },
    three:  { value: 3, desc: 'three star' },
    four:   { value: 4, desc: 'four star' },
    five:   { value: 5, desc: 'five star' }
  }
end
