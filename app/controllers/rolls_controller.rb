class RollsController < ApplicationController
  VALID_EXPIRE_DATE_PERIODS = %w{minutes hours days weeks months years}
  def new
    @roll = Roll.new
  end

  def create
    require 'net/http'

    @roll = Roll.new(params[:roll])

    if params[:which_roll] == 'classic'
      @roll.roll_url = Roll::RICK_ROLL_URL
    end

    if params[:use_expiry_date] && (params[:expire_date_num].to_i > 0) && VALID_EXPIRE_DATE_PERIODS.include?(params[:expire_date_period])
        @roll.expires_at = eval("#{params[:expire_date_num].to_i}.#{params[:expire_date_period]}.from_now")
    end

    if @roll.save
      @roll.snip_url = Net::HTTP.get_response('snipr.com', "/site/snip?r=simple&link=http://rickroll.tv/rolls/show/#{@roll.id}").body
      @roll.save
      redirect_to :action => :preview, :id => @roll.id
      #render :action => :preview
    else
      render :action => :new
    end
  end

  def show
    @roll = Roll.find params[:id]
    add_hit

    if do_roll?
      if @roll.user
        @roll.user.number_of_rolls += 1
        @roll.user.save
      end
      #add hit for user
      redirect_to @roll.roll_url
    else
      redirect_to @roll.destination_url
    end

    if @roll.hits_until_expired
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
    @hit = Hit.find_or_create_by_roll_id_and_referrer(@roll.id, request.referer)
    @hit.count += 1
    @hit.save
  end
end
