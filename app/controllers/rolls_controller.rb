class RollsController < ApplicationController
  VALID_EXPIRE_DATE_PERIODS = %w{minutes hours days weeks months years}

  def new
    @roll = Roll.new
  end

  def create
    @roll = Roll.new(params[:roll]) do |roll|
      if params[:which_roll] == 'classic'
        roll.roll_url = Roll::RICK_ROLL_URL
      end

      if params[:use_expiry_date] && (params[:expire_date_num].to_i > 0) && VALID_EXPIRE_DATE_PERIODS.include?(params[:expire_date_period])
        roll.expires_at = params[:expire_date_num].to_i.send(params[:expire_date_period]).from_now
      end
    end
    
    begin
      @roll.save!

      @roll.snip_url = Net::HTTP.get_response('snipr.com', "/site/snip?r=simple&link=#{roll_url(@roll)}").body
      @roll.save!

      redirect_to :action => :preview, :id => @roll.id
    rescue SocketError, Timeout::Error
      flash[:notice] = "Due to a network error, we were unable to build a snipurl for your link."
      render :action => :new
    rescue ActiveRecord::RecordInvalid
      render :action => :new
    end
  end

  def show
    @roll = Roll.find params[:id]
    hit_added = add_hit

    if do_roll?
      if @roll.user && hit_added
        @roll.user.number_of_rolls += 1
        @roll.user.save
      end
      #add hit for user
      redirect_to @roll.roll_url
    else
      redirect_to @roll.destination_url
    end

    if @roll.hits_until_expired && hit_added
      @roll.hits_until_expired -= 1
      @roll.expired = true if @roll.hits_until_expired == 0
      @roll.save
    end
  end

  def preview
    @roll = Roll.find params[:id]
  end

  protected

  def do_roll?
    return true if @roll.expired?

    if @roll.expires_at && (@roll.expires_at < Time.now )
      @roll.expired = true
      @roll.save
      return true
    end

    unless @roll.probability.nil?
      return rand(100) < @roll.probability
    end

    false
  end

  def add_hit
    return false if url_for(:action => :preview, :id => @roll.id) == request.referer
    @hit = Hit.find_or_create_by_roll_id_and_referrer(@roll.id, request.referer)
    #TODO if request.referer is nil maybe we should record the IP address, (track bots and stuff)
    # or maybe just reject
    @hit.count += 1
    @hit.save
  end
end
