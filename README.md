# Byteman

Simple gem to allow manipulation of data into other forms. Specifically, transform data between byte buffers (integer arrays with every number representing a byte ie an integer from 0-255), hexdigest strings, hex strings, and integers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'byteman'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install byteman

## Usage

See spec for most examples. Usage is relatively simple. For example, the `.hex` method can transform hexdigest strings, byte arrays, and integers into its corresponding hex string. For example: 

```ruby
Byteman.hex(123456) #=> "\x01\xE2@"
Byteman.hex([92, 123, 1, 209]) #=> "\\{\x01\xD1"
```

You can pad your numbers to a specific byte length or bit length using the `.pad` method: 

```ruby
Byteman.pad(num: [43,223], len: 4) #=> [0,0,43, 223]
Byteman.pad(num: 1234, len: 4) #=> "\x00\x00\x04\xD2"
Byteman.pad(num: "\xE3\x09", len: 8) #=> "\x00\x00\x00\x00\x00\x00\xE3\x09"
Byteman.pad(num: 42, len: 8, type: :bits) #=> "00101010"
Byteman.pad(num: "11001", len: 16, type: :bits) #=> "0000000000011001"
```
And there are more methods to facilitate easy manipulation of bytestreams. All are documented with rdoc and are tested in the spec folder. Some of these methods are:

`.digest2buf`, which turns a hexdigest string into a byte buffer:
```ruby
Byteman.digest2buf("68656c6c6f20776f726c64") #=> [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100]
```

`.digest2int`, which turns a hexdigest string into an integer:
```ruby
Byteman.digest2int("168656c6c6f20776f726c64") #=> 435692254137895873546447972

```

And similar methods such as `.hexdigest`, `.buf2int`, etc. 


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/byteman. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/byteman/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Byteman project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/byteman/blob/master/CODE_OF_CONDUCT.md).
