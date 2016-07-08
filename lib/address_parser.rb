require "csv"

class AddressParser

  def read(data)
    data.parse_csv
  end

  def read_from_file(path)
    CSV.read(path)
  end

  def get_addresses(path)
    addresses = []
    CSV.foreach(path) do |row|
      addresses << row[-1]
    end
    addresses.shift # delete "FULL_ADDRESS"
    addresses
  end

end
