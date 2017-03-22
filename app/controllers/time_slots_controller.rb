class TimeSlotsController < ApplicationController
  before_action :authenticate_user!,only:[:index]
  before_action :token_authentication, only: [:daily_time_slots]
  before_action :set_time_slot, only: [:show, :edit, :update, :destroy]
  before_action :validation_date, only: [:daily_time_slots]
  before_filter :set_format, only: [:daily_time_slots]

  def index
    if params[:start_date].present? && params[:end_date].present?
      @time_slots = TimeSlot.where('date BETWEEN ? AND ?', params[:start_date], params[:end_date])
    else
      curent_date = Time.now.strftime("%Y-%m-%d")
      @time_slots = TimeSlot.where(date: curent_date)
    end
    @time_slots = @time_slots.page(params[:page])
    @time_slot = TimeSlot.new
  end

  def show
  end

  def new
    @time_slot = TimeSlot.new
  end

  def edit
  end

  def create
    @time_slot = TimeSlot.new(time_slot_params)

    respond_to do |format|
      if @time_slot.save
        format.html { redirect_to time_slots_path(), notice: 'Time slot was successfully created.' }
        format.json { render :show, status: :created, location: @time_slot }
      else
        format.html { render :new }
        format.json { render json: @time_slot.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @time_slot.update(time_slot_params)
        format.html { redirect_to time_slots_path(), notice: 'Time slot was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_slot }
      else
        format.html { render :edit }
        format.json { render json: @time_slot.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @time_slot.destroy
    respond_to do |format|
      format.html { redirect_to time_slots_url, notice: 'Time slot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def daily_time_slots
    @time_slots = TimeSlot.where(date: @date)
  end

  private
    def set_time_slot
      @time_slot = TimeSlot.find(params[:id])
    end

    def time_slot_params
      params.require(:time_slot).permit(:date, :start_time, :end_time, :charges)
    end

    def validation_date
      return render json: { error: 'date is empty'}, status: 404 if params[:date].blank?
      begin
        @date = Date.parse(params[:date])
      rescue
        return render json: { error: 'Invalid date format. Please use yyyy-mm-dd'}, status: 404
      end
    end
end
