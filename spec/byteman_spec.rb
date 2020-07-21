RSpec.describe Byteman do
  it "has a version number" do
    expect(Byteman::VERSION).not_to be nil
  end

  describe ".pad" do
    it "correclty pads a byte array to another byte array of the correct length" do
      expect(Byteman.pad(num: [43,223], len: 4)).to eq([0,0,43, 223])
    end
    
    it "correctly pads a number to an array of bytes to the correct length" do 
      expect(Byteman.pad(num: 1234, len: 4).bytes).to eq("\x00\x00\x04\xD2".bytes)
    end

    it "correctly pads hex string to the correct number of bytes" do 
      expect(Byteman.pad(num: "\xE3\x09", len: 8).bytes).to eq("\x00\x00\x00\x00\x00\x00\xE3\x09".bytes)
    end

    it "correctly pads a number to a bit length" do 
      expect(Byteman.pad(num: 42, len: 8, type: :bits)).to eq("00101010")
    end

    it 'correctly pads a number to a bit length when the number is already the appropriate size' do 
      expect(Byteman.pad(num: 2, len: 2, type: :bits)).to eq("10")
    end

    it "correctly reduces the size of a number to a bit length when the the number is too large" do 
      expect(Byteman.pad(num: 4, len: 2, type: :bits)).to eq('00')
    end

    it 'correctly pads a number to a byte length when the number is already the appropriate size' do 
      expect(Byteman.pad(num: Byteman.buf2int([1,0,0,1,1]), len: 4)).to eq(Byteman.hex([0,0,1,1]))
    end

    it "correctly reduces the size of a number to a byte length when the the number is too large" do 
      expect(Byteman.pad(num: 255, len: 2).bytes).to eq("\x00\xff".bytes)
    end

    it "can pad on the LSB side of the number" do
      expect(Byteman.pad(num: 42, len: 8, type: :bits, lsb: true)).to eq("10101000")
      expect(Byteman.pad(num: "\xE3\x09", len: 8, lsb: true).bytes).to eq("\xE3\x09\x00\x00\x00\x00\x00\x00".bytes)
    end

    it "correctly pads a bit string to a bit length" do
      expect(Byteman.pad(num: "11001", len: 16, type: :bits)).to eq("0000000000011001")
    end

    it "raises an error if the wrong type is inputted" do 
      expect{Byteman.pad(num: 3244, len: 8, type: :byte)}.to raise_error(ArgumentError)
    end
    
    it "raises an error if the wrong type of number is inputted" do 
      expect{Byteman.pad(num: 32.23, len: 4)}.to raise_error(ArgumentError)
    end
  end

  describe ".str2digest" do
    it "correctly transforms a string to its hexdigest" do 
      expect(Byteman.str2digest("hello world")).to eq("68656c6c6f20776f726c64")
    end
  end

  describe ".digest2buf" do

    it "correctly transforms a string digest into a buffer array" do
      expect(Byteman.digest2buf("68656c6c6f20776f726c64")). to eq([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100])
    end

  end

  describe ".digest2int" do
    it "correctly transforms a hex digest into its corresponding integer" do 
      expect(Byteman.digest2int("168656c6c6f20776f726c64")).to eq(435692254137895873546447972)
    end
  end

  describe '.hex' do 
    it 'correctly turns an Integer into its hex value' do
      expect(Byteman.hex(435692254137895873546447972)).to eq("\x01hello world")
    end

    it "correctly turns a hexdigest string into its corresponding hex value" do
      out = Byteman.hex("4ff9a4c")
      expect(out.bytes).to eq("\x04\xff\x9a\x4c".bytes)
      expect(out).to be_a(String)
    end

    it "correctly turns a byte integer array into its corresponding hex value" do
      expect(Byteman.hex([31, 245, 9, 83, 125]).bytes).to eq("\x1F\xF5\tS}".bytes)
      expect(Byteman.hex([31, 245, 9, 83, 125])).to be_a(String)
    end

    it "raises an ArgumentError if the input is not the correct type" do 
      expect{Byteman.hex(3235.124)}.to raise_error(ArgumentError)
    end
  end

  describe "hexdigest" do 
    it "correctly transforms an integer into its hexdigest string" do
      expect(Byteman.hexdigest(3253)).to eq("0cb5")
    end

    it "correctly transforms an integer array into its hex digest string" do
      expect(Byteman.hexdigest([93,128,255,0,2])).to eq("5d80ff0002")
    end

    it "correctly transforms a string into his hex digest" do 
      expect(Byteman.hexdigest("hello world")).to eq("68656c6c6f20776f726c64")
    end

    it "throws an argument error if the improper datatype is inputted" do
      expect{Byteman.hexdigest([4,29,392,1])}.to raise_error(ArgumentError)
      expect{Byteman.hexdigest(32.5)}.to raise_error(ArgumentError)
    end
  end

  describe ".buf2digest" do 

    it "correctly transforms an integer array into its hexdigest string" do
      expect(Byteman.hexdigest([93,128,255,0,2])).to eq("5d80ff0002")
    end
  end

  describe '.buf2hex' do

    it "correctly transforms an integer array into a hex string" do
      expect(Byteman.hex([31, 245, 9, 83, 125]).bytes).to eq("\x1F\xF5\tS}".bytes)
      expect(Byteman.hex([31, 245, 9, 83, 125])).to be_a(String)
    end
  end

  describe '.buf2int' do

    it 'correctly transforms an integer array of bytes into its corresponding integer' do
      expect(Byteman.buf2int([32, 125, 9, 0, 84])).to eq(139536695380)
    end
  end

  describe '.int2buf' do

    it 'correctly transforms an integer into its byte integer array' do

      expect(Byteman.int2buf(139536695380)).to eq([32, 125, 9, 0, 84])

    end

  end

  describe '.hex2int' do

    it 'correctly transforms a hex string to its corresponding integer' do 
      expect(Byteman.hex2int("hello world")).to eq(126207244316550804821666916)
    end
  end

end
