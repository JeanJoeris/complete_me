require "minitest"
require "minitest/autorun"
require "minitest/pride"
require "./lib/complete_me"
require "pry"

class AddressParserTest < Minitest::Test


  def test_add_address_exists
    skip # for the sake of how long it takes, remove skip to confirm it works
    cm = CompleteMe.new
    cm.add_addresses
    assert cm
  end

  def test_add_addresses_populates_tree
    skip
    cm = CompleteMe.new
    cm.add_addresses
    assert_equal 290589, cm.count
  end

  def test_suggest_address_the_one_right_address
    skip
    cm = CompleteMe.new
    cm.add_addresses

    assert_equal ["4942 N Altura St"], cm.suggest("4942 N Alt")
  end

  def test_suggest_multiple_addresses
    skip
    cm = CompleteMe.new
    cm.add_addresses
    expected_addresses = ["4942 N Altura St", "4942 W Custer Pl", "4942 W 9th Ave", "4942 W Union Ave", "4942 W 38th Ave", "4942 S Field Ct", "4942 S Hoyt St", "4942 Morrison Rd", "4942 N Yosemite St", "4942 N Verbena St", "4942 N Wabash St", "4942 N Willow St", "4942 N Jasper St", "4942 N Titan Way", "4942 N Eureka Ct", "4942 N Raleigh St", "4942 N Fontana Ct", "4942 N Grove St", "4942 N Xanthia St", "4942 N Xanadu St", "4942 N Saint Paul St", "4942 N Scranton St", "4942 N Upton Ct", "4942 N Cathay St", "4942 W 46th Ave"]
    assert_equal expected_addresses, cm.suggest("4942")
  end

  def test__1_select_weights_1_addresses
    skip

    cm = CompleteMe.new
    cm.add_addresses
    cm.select("4942", "4942 W 9th Ave")
    first_suggestion = cm.suggest("4942").first
    assert_equal "4942 W 9th Ave", first_suggestion
  end

  def test_multiple_selects_correctly_orders
    cm = CompleteMe.new
    cm.add_addresses
    3.times do
      cm.select("4404 N A", "4404 N Alcott St Bldg 1")
    end
    2.times do
      cm.select("19th St"," 19th St Unit 4032")
    end
    most_selected = cm.suggest("440")[0..20]
    second_most_selected = cm.suggest("19th")[0..20]
    binding.pry
    # assert_equal "4404 N Alcott St Bldg 1", cm.suggest("4").first
    # assert_equal "19th St Unit 4032", cm.suggest("19th").first

    assert_equal most_selected, second_most_selected

  end

end
