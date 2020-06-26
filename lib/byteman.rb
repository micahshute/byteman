require "byteman/version"

## 
# A simple module with methods that allow easy manipulation of data into other forms.
# Specifically focused on bytes, digests, and integer byte arrays (buffers)


module Byteman
  ##
  # A simple module with methods to allow you to easily manipulate
  # data into different forms, such as strings and numbers to their hex digests,
  # and back again, digests, numbers, and byte buffers into their bytes,
  # padding 
    

  # pad args
  #
  # num: (named) [Array or Integer or String] Accepts an array of integers representing bytes (0-255), or an integer of any size (less than the pad size), or a byte string
  #
  # len: (named) [Integer] The number of bytes you want to pad this number to 
  #
  # type: (named) [Symbol] (default: :bytes) Determines if you are padding bytes or bits. Defaults to :bytes, also accepts :bits
  # 
  # Note that this pads 0s to the front of the number, and returns a byte string if an integer or string is the input arg, and returns an array buffer if an array buffer is entered
  #
  # Unexpected results will occur if the number is greater than the number of total padded byte length
  def self.pad(num: nil, len: , type: :bytes)
    raise ArgumentError.new("Type must be :bytes or :bits") if type != :bytes && type != :bits
    if type == :bytes
      if num.is_a?(Array)
        overflow = len - (num.length % len)
        return [0] * overflow + num
      elsif num.is_a?(Integer)
        hex(pad(num: int2buf(num), len: len))
      elsif num.is_a?(String)
        pad(num: num.unpack("C*"), len: len).pack("C*")
      else
        raise ArgumentError.new("Num must be a Array, Integer, or ByteString")
      end
    else
      if num.is_a?(Integer)
        bin_num = num.to_s(2)
      elsif num.is_a?(String) && num.split('').all?{ |n| n == "0" || n == "1"}
        bin_num = num
      else
        raise ArgumentError("If performing bit padding, the input must be an Integer or a string of bits")
      end
      overflow = len - (bin_num.length % len)
      padded = "0" * overflow + bin_num
      return padded
    end
  end


  # str2digest args
  #
  # str: [String] the string whose bytes will be turned into a hexdigest representation of the data
  #
  # Returns a hexdigest string
  def self.str2digest(str)
    str.bytes.map do |b| 
      hexdigest(b)
    end.join('')
  end

  # digest2buf args
  # 
  # dig: [String] a string hexdigest that will be turned into an array of the represented bytes (the array will be half the length of the number of characters in the digest)
  # 
  # Returns an integer array representing the bytes of the hexdigest
  def self.digest2buf(dig)
    hex2buf(hex(dig))
  end

  # hex2buf args
  #
  # hex: [String] hex string
  #
  # Returns an array of Integers, each representing a byte of data
  def self.hex2buf(hex)
    hex.unpack("C*")
  end

  # digest2int args
  # 
  # dig: [String] hexdigest string
  # 
  # Returns a byte String half the length of the hexdigest
  def self.digest2int(dig)
    dig.to_i(16)
  end

  # hex args
  # 
  # input: [Integer or String or Array] accepts any Integer, or a hexdigest String or an integer array (byte buffer) with all numbers between 0-255 inclusive
  # 
  # Returns a byte String. 
  # 
  # Note -> Automatically pads a 0 nibble to the front of any odd-lengthed hexdigest
  def self.hex(input)
    if input.is_a?(Integer)
      hex(hexdigest(input))
    elsif input.is_a?(String)
      hd = input.length.odd? ? "0#{input}" : input
      [hd].pack("H*")
    elsif input.is_a?(Array)
      input.pack("C*")
    else
      raise ArgumentError.new("Input must be a string, number, or byte array buffer")
    end
  end

  # hexdigest args
  # 
  # arg: [Integer or String or Array] accepts any Integer or String or Array of Integers from 0-255 
  # 
  # Returns a hexdigest string
  def self.hexdigest(arg)
    if arg.is_a?(Integer)
      dig = arg.to_s(16)
      dig.length.odd? ? "0#{dig}" : dig
    elsif arg.is_a?(Array) && arg.all?{|a| a.between?(0,255)}
      buf2digest(arg)
    elsif arg.is_a?(String)
      arg.unpack("H*").first
    else
      raise ArgumentError.new("Input must be an integer, Array of integers between 0-255, or String")
    end
  end

  # buf2digest args
  # 
  # barr: [Array] accepts an integer array (ints between 0-255 inclusive)
  # 
  # Returns a hexdigest string
  def self.buf2digest(barr)
    barr.pack("C*").unpack("H*").first
  end

  # buf2hex args
  # 
  # barr: [Array] accepts an integer array (ints between 0-255 inclusive)
  # 
  # Returns a byte String 
  def self.buf2hex(barr)
    barr.pack("C*")
  end

  # buf2int args
  # 
  # barr: [Array] accepts an integer array (ints between 0-255 inclusive)
  # 
  # Returns the Integer represeted by the byte array buffer
  def self.buf2int(barr)
    buf2digest(barr).to_i(16)
  end

  # int2buf args
  # 
  # num: [Integer] any integer
  # 
  # Returns an array of Integers between 0-255 inclusive, representing the byte buffer array
  def self.int2buf(num)
    hex(num).bytes
  end

  # hex2int args
  # 
  # hex: [String] 
  # 
  # Returns the integer represented by the inputted hex string
  def self.hex2int(hex)
    hex.unpack("H*").first.to_i(16)
  end
end
