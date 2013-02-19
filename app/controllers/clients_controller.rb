class ClientsController < ApplicationController
  #client function: GET clients
  def client
      respond_to do |format|
          format.html { render :action => "client" }
      end
  end

  #login function: POST /users/login
  def login
    #handle unexpected error with status code 500
    begin
      if request.env['CONTENT_TYPE'] == 'application/json'
        @client = Client.new
        errCode = @client.login(params[:user], params[:password])
        if errCode > 0
          dic = {:errCode => 1, :count => errCode}
          respond_to do |format|
            format.json { render json: dic, :status => 200 }
          end
        else
          dic = {:errCode => errCode}
          respond_to do |format|
            format.json { render json: dic, :status => 200 }
          end
        end
      else
        render :json => { :errors => "Wrong Content-Type on Request'" }, :status => 500
      end
    rescue
      render :json => { :errors => "Unknown Errors" }, :status => 500
    end
  end

  #add function: POST /users/add
  def add
    #handle unexpected error with status code 500
    begin
      if request.env['CONTENT_TYPE'] == 'application/json'
        @client = Client.new
        @username = params[:user]
        @password = params[:password]
        errCode = @client.add(params[:user], params[:password])
        if errCode > 0
          dic = {:errCode => 1, :count => errCode}
          respond_to do |format|
            format.json { render json: dic, :status => 200 }
          end
        else
          dic = {:errCode => errCode}
          respond_to do |format|
            format.json { render json: dic, :status => 200 }
          end
        end
      else
        render :json => { :errors => "Wrong Content-Type on Request'" }, :status => 500
      end
    rescue
      render :json => { :errors => "Unknown Errors" }, :status => 500
    end
  end

  #reset database: POST /TESTAPI/resetFixture 
  def resetFixture
    #handle unexpected error with status code 500
    begin
      @client = Client.new
      errCode = @client.TESTAPI_resetFixture()
      dic = {:errCode => 1}
      respond_to do |format|
        format.json { render json: dic, :status => 200 }
      end
    rescue
      render :json => { :errors => "Unknown Errors" }, :status => 500
    end
  end

  #calling unit tests in test/unit: POST /TESTAPI/unitTests
  def unitTests
    #handle unexpected error with status code 500
    begin
      system("rake test:units > output.txt")
      aFile = File.new("output.txt", "r")
      data = aFile.readlines
      aFile.close()
      totalTests = Integer(data[-1].split(",")[0].split(" ")[0])
      nrFailed = Integer(data[-1].split(",")[-2].split(" ")[0]) + Integer(data[-1].split(",")[-3].split(" ")[0])
      if nrFailed == 0
        dic = {:totalTests => totalTests, :nrFailed => 0, :output => "unitTests all passes"}
      else
        aFile = File.new("output.txt", "r")
        output = aFile.read.split("\n").join
        aFile.close()
        dic = {:totalTests => totalTests, :nrFailed => nrFailed, :output => output}
      end
      respond_to do |format|
        format.json { render json: dic, :status => 200 }
      end
    rescue
      render :json => { :errors => "Unknown Errors" }, :status => 500
    end
  end
end
