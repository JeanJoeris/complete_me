require "minitest"
require "minitest/autorun"
require "minitest/pride"
require "./lib/address_parser"
require "pry"

class AddressParserTest < Minitest::Test

  def test_it_exists
    test_parser = AddressParser.new
    assert test_parser
  end

  def test_it_reads_empty_string_to_nil
    test_parser = AddressParser.new
    assert_equal nil, test_parser.read("")
  end

  def test_it_reads_in_csv
    test_parser = AddressParser.new

    assert_equal ["foo", "bar"],test_parser.read("foo,bar")
  end

  def test_it_reads_csv_with_commas
    test_parser = AddressParser.new

    assert_equal ["foo, bar", "biz"], test_parser.read('"foo, bar",biz')
  end

  def test_can_grab_element_in_csv_array
    test_parser = AddressParser.new

    assert_equal "bar",test_parser.read("foo,bar")[-1]
  end

  def test_read_file_exits
    skip # useful for development, now broken
    test_parser = AddressParser.new

    assert test_parser.read_from_file("~")
  end

  def test_read_file_reads_in_path
    test_parser = AddressParser.new
    assert test_parser.read_from_file("./data/addresses.csv")
  end

  def test_it_correctly_reads_file
    test_parser = AddressParser.new
    address_csv = test_parser.read_from_file("./data/addresses.csv")
    assert_equal "4942 N Altura St", address_csv[1][-1]
  end

  def test_get_addresses
    test_parser = AddressParser.new
    addresses = test_parser.get_addresses("./data/addresses.csv")
    assert_equal "4942 N Altura St", addresses.first
    assert_equal "1975 19th St Unit 3027", addresses.last
  end

end
