module RollsHelper
  def expire_date_num_select
    options = options_for_select(1..60)
    select_tag 'expire_date_num', options
  end

  def expire_date_period_select
    options = options_for_select RollsController::VALID_EXPIRE_DATE_PERIODS
    select_tag 'expire_date_period', options
  end
end
