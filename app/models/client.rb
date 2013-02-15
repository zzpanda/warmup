class Client < ActiveRecord::Base
  attr_accessible :username, :password

  def login(user, password)
  	@client = Client.where(:username => user).first
    if @client.nil? || @client.password != password
      return -1
    else
      @client.count +=1
      @client.save
      return @client.count
    end
  end

  def add(user, password)
  	@client = Client.where(:username => user).first
    if user.length == 0 || user.length > 128
      return -3
    elsif password.length > 128
      return -4
    elsif !@client.nil?
      return -2
    else
      @client = Client.new(:username => user, :password => password)
      @client.count = 1
      @client.save
      return 1
    end
  end

  def TESTAPI_resetFixture()
	  Client.delete_all
	  return 1
  end
end
