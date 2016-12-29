# SmartAttr

This gem helps you make your model's attribute smart.You can get many useful methods with only a little code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smart_attr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smart_attr

## Usage

### Basic Usage(Without database)

'Without database' means that your model does not inherit from something like ActiveRecord::Base, and does not include something like Mongoid::Document.

You can see more details in the example below:

```ruby
class Movie

  include SmartAttr::Base

  smart_attr :star, config: {
    one:    { value: 1, desc: 'one star' },
    two:    { value: 2, desc: 'two star' },
    three:  { value: 3, desc: 'three star' },
    four:   { value: 4, desc: 'four star' },
    five:   { value: 5, desc: 'five star' }
  }
end

Movie.star_config_hash
# => { :one=>{:value=>1, :desc=>"one star"},
#      :two=>{:value=>2, :desc=>"two star"},
#      :three=>{:value=>3, :desc=>"three star"},
#      :four=>{:value=>4, :desc=>"four star"},
#      :five=>{:value=>5, :desc=>"five star"}
#    }

movie = Movie.new # => #<Movie:0x007fcc041b0490>

movie.star = 1  # => 1
movie.star_name # => :one
movie.star_desc # => "one star"
movie.star_one? # => true
movie.star_two? # => false

movie.star_two! # => 2
movie.star      # => 2
movie.star_two? # => true

movie.star_config # => {:value=>2, :desc=>"two star", :key=>:two}
```

In this situation, an instance_variable is created to store the value when you set value for the attribute.

For example:

```ruby
movie = Movie.new # => #<Movie:0x007fcc041b0490>
movie.star = 3 # =>3

# By run 'movie.inspect', you can see that there is an instance_variable named '@star'.
movie.inspect # => "#<Movie:0x007fcc041b0490 @star=3>"
```

### Used With ActiveRecord

It is almost the same like the basic usage when used with ActiveRecord.

There is just one difference between this and the basic usage, however, there is one extra  functionality when used with ActiveRecord.

The only one difference is that it will not create an instance_variable to store the value when you set value for the attribute.
This is because it will store the value in the database. 
And the extra functionality is that it will define scope for you when used with ActiveRecord.

For example, suppose you have a class named "Movie" with database table 'movies', then you should ensure that 'movies' have column 'star' before you use 'smart_attr :star, config: { # something }'

```ruby
class Song < ActiveRecord::Base

  include SmartAttr::Base

  smart_attr :star, config: {
    one:    { value: 1, desc: 'one star' },
    two:    { value: 2, desc: 'two star' },
    three:  { value: 3, desc: 'three star' },
    four:   { value: 4, desc: 'four star' },
    five:   { value: 5, desc: 'five star' }
  }

end


song = Song.new(star: 0)

song.save

song.star = 1  # => 1
song.star_name # => :one
song.star_desc # => "one star"
song.star_one? # => true
song.star_two? # => false

song.star_two! # => 2
song.star      # => 2
song.star_two? # => true

song.reload
song.star # => 1
song.star_two!
song.save
song.reload
song.star # => 2

song.star_config # => {:value=>2, :desc=>"two star", :key=>:two}

# scope
Song.star_one # The same as: Song.where(star: 1)
Song.star_two # The same as: Song.where(star: 2)
```

### Used With Mongoid

Same like used with ActiveRecord.


## Supported Ruby Version
From 2.0.0 To 2.3.3

NOTE: 2.4.0 is not supported yet!

## Status
[![Build Status](https://travis-ci.org/liukgg/smart_attr.png)](https://travis-ci.org/liukgg/smart_attr)

## TODO
- Introduce SimpleCov

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/liukgg/smart_attr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

