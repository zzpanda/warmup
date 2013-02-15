require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  SUCCESS = 1
  ERR_BAD_CREDENTIALS = -1
  ERR_USER_EXISTS = -2
  ERR_BAD_USERNAME = -3
  ERR_BAD_PASSWORD = -4
  INVALID_STRING = "z"*129

  test "reset sucess" do
    @client = Client.new
    assert_equal @client.TESTAPI_resetFixture(), SUCCESS
    assert_equal Client.all.length, 0
  end

  test "add success" do
  	@client = Client.new
    Client.delete_all
    assert_equal @client.add("zz", "zz"), SUCCESS
    assert Client.find_by_username("zz")
    assert Client.find_by_password("zz")
    assert_equal Client.find_by_password("zz").count, 1
  end

  test "add user exists" do
  	@client = Client.new
    Client.delete_all
    @client.add("zz", "zz")
  	assert_equal @client.add("zz", ""), ERR_USER_EXISTS
  	assert !Client.find_by_password("")
  end

  test "add bad username" do
  	@client = Client.new
    Client.delete_all
  	assert_equal @client.add("", "aa"), ERR_BAD_USERNAME
  	assert !Client.find_by_password("aa")
  	assert_equal @client.add(INVALID_STRING, "aa"), ERR_BAD_USERNAME
    assert !Client.find_by_password("aa")
  end

  test "add bad password" do
  	@client = Client.new
    Client.delete_all
  	assert_equal @client.add("bb", INVALID_STRING), ERR_BAD_PASSWORD
  	assert !Client.find_by_username("bb")
  end

  test "login success" do
  	@client = Client.new
    Client.delete_all
    @client.add("zz", "zz")
  	assert_equal @client.login("zz", "zz"), 2
  end

  test "login user not exist" do
  	@client = Client.new
    Client.delete_all
    @client.add("zz", "zz")
  	assert_equal @client.login("cc", "zz"), ERR_BAD_CREDENTIALS
  end

  test "login wrong password" do
  	@client = Client.new
    Client.delete_all
    @client.add("zz", "zz")
  	assert_equal @client.login("zz", "aa"), ERR_BAD_CREDENTIALS
  end

  test "login bad username" do
  	@client = Client.new
    Client.delete_all
  	assert_equal @client.login("", "aa"), ERR_BAD_CREDENTIALS
    assert !Client.find_by_password("aa")
  	assert_equal @client.login(INVALID_STRING, "aa"), ERR_BAD_CREDENTIALS
    assert !Client.find_by_password("aa")
  end

  test "login bad password" do
  	@client = Client.new
    Client.delete_all
  	assert_equal @client.login("dd", INVALID_STRING), ERR_BAD_CREDENTIALS
    assert !Client.find_by_username("dd")
  end
end





