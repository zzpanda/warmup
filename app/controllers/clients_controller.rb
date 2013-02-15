class ClientsController < ApplicationController
  # GET /clients/1
  # GET /clients/1.json
  
  """def show
    @client = Client.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end"""

  def login
    begin
      if request.env['CONTENT_TYPE'] == 'application/json'
        @client = Client.new
        errCode = @client.login(params[:user], params[:password])
        if errCode > 0
          dic = {:errCode => 1, :count => errCode}
          respond_to do |format|
            #format.html # should go to logout but not new
            #logger.debug "#{@dic}"
            format.json { render json: dic, :status => 200 }
            #render :json => { :errors => @contacts.errors.as_json }, :status => 420
            #format.json { render json: @client }
          end
        else
          dic = {:errCode => errCode}
          respond_to do |format|
            #format.html # should stay at new
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

  def add
    #@a = request.env['CONTENT_TYPE']
    #logger.debug "#{@a}"
    begin
      if request.env['CONTENT_TYPE'] == 'application/json'
        @client = Client.new
        @username = params[:user]
        @password = params[:password]
        #logger.debug "#{@username}"
        errCode = @client.add(params[:user], params[:password])
        if errCode > 0
          dic = {:errCode => 1, :count => errCode}
          respond_to do |format|
            #format.html # should go to logout but not new
            #logger.debug "#{@client}"
            #logger.debug "#{@dic}"
            format.json { render json: dic, :status => 200 }
          end
        else
          #logger.debug "#{@client}"
          dic = {:errCode => errCode}
          #logger.debug "#{@dic}"
          respond_to do |format|
            #format.html # should stay at new
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

  def resetFixture
    #@a = request.env['CONTENT_TYPE']
    #logger.debug "#{@a}"
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

  def unitTests
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

  """# GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
    end
  end"""

  """
  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(params[:client])
    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end"""
end
