class Client < ActiveRecord::Base
  attr_accessible :username, :password

  #different situations correspond to different errcodes
  SUCCESS = 1
  ERR_BAD_CREDENTIALS = -1
  ERR_USER_EXISTS = -2
  ERR_BAD_USERNAME = -3
  ERR_BAD_PASSWORD = -4

  #login function with two parameters (username, password) passed in
  def login(user, password)
  	@client = Client.where(:username => user).first
    if @client.nil? || @client.password != password
      return ERR_BAD_CREDENTIALS
    else
      @client.count +=1
      @client.save
      return @client.count
    end
  end

  #add user functiion with two parameters (username, password) passed in 
  def add(user, password)
  	@client = Client.where(:username => user).first
    if user.length == 0 || user.length > 128
      return ERR_BAD_USERNAME
    elsif password.length > 128
      return ERR_BAD_PASSWORD
    elsif !@client.nil?
      return ERR_USER_EXISTS
    else
      @client = Client.new(:username => user, :password => password)
      @client.count = 1
      @client.save
      return SUCCESS
    end
  end

  #delete all the data in database
  def TESTAPI_resetFixture()
	  Client.delete_all
	  return SUCCESS
  end
end
