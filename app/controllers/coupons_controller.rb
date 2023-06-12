class CouponsController < ApplicationController
  before_action :find_coupon_and_merchant, only: [:show, :edit, :update]
  before_action :find_merchant, only: [:index, :new, :create]
  before_action :active_coupon_limit, only: [:update]

  def index
    @coupons = @merchant.coupons
    @active_coupons = @merchant.coupons.active
    @inactive_coupons = @merchant.coupons.inactive
    @holidays = HolidaySearch.new.new_holiday(3)
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def new
  end

  def create
    @coupon1 = Coupon.new(coupon_params)
    if @coupon1.valid?
      @coupon1.save
      flash.notice = "New Coupon has been created!"
      redirect_to merchant_coupons_path(@merchant)
    else
      redirect_to new_merchant_coupon_path(@merchant)
      flash.notice =  "Error: #{@coupon1.errors.full_messages.to_sentence}"
    end
  end

  def edit
  end

  def update
    if params[:status] == "active"
      @coupon.update(status: "active")
      redirect_to merchant_coupon_path(@merchant, @coupon)
    elsif params[:status] == "inactive"
      @coupon.update(status: "inactive")
      redirect_to merchant_coupon_path(@merchant, @coupon)
    end
  end

  private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def coupon_params
    params.permit(:name, :unique_code, :amount_off, :discount_type, :merchant_id, :status)
  end

  def find_coupon_and_merchant
    @coupon = Coupon.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def active_coupon_limit
    @merchant = Merchant.find(params[:merchant_id])
    @active_coupons = @merchant.coupons.active
    if @active_coupons.count >= 5
      flash.notice = "Error: You cannot have more than 5 active coupons, please deactivate one first"
      redirect_to merchant_coupons_path(@merchant)
    end
  end
end