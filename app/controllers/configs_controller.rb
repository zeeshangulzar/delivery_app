class ConfigsController < ApplicationController

  before_action :authenticate_user!,only:[:index, :import]
  before_action :set_config, only: [:show, :edit, :update, :destroy]

  def index
    @configs = Config.get_list(params)
    @config = Config.new
  end

  def new
    @config = Config.new
  end

  def edit
  end

  def show
  end

  def create
    @config = Config.new(config_params)

    respond_to do |format|
      if @config.save
        format.html { redirect_to configs_path(), notice: 'Configuration was successfully created.' }
        format.json { render :show, status: :created, location: @config }
      else
        format.html { render :new }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @config.update(config_params)
        format.html { redirect_to configs_path(), notice: 'Configuration was successfully updated.' }
        format.json { render :show, status: :ok, location: @config }
      else
        format.html { render :edit }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @config.destroy
    respond_to do |format|
      format.html { redirect_to configs_url, notice: 'Configuration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def config_params
      params.require(:config).permit(:title, :description, :api)
    end

    def set_config
      @config = Config.find(params[:id])
    end

end
