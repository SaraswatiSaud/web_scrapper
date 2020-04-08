# frozen_string_literal: true

# AppsController
class AppsController < ApplicationController
  before_action :set_app, only: %i[show edit update destroy]

  # GET /apps
  # GET /apps.json
  def index
    @apps = App.all
  end

  # GET /apps/1
  # GET /apps/1.json
  def show; end

  # GET /apps/new
  def new
    @app = App.new
  end

  # GET /apps/1/edit
  def edit; end

  # POST /apps
  # POST /apps.json
  def create
    @app = App.new(app_params)

    respond_to do |format|
      if @app.save
        format.html do
          redirect_to @app,
                      notice: 'App was successfully created.'
        end
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apps/1
  # PATCH/PUT /apps/1.json
  def update
    respond_to do |format|
      if @app.update(app_params)
        format.html do
          redirect_to @app,
                      notice: 'App was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @app }
      else
        format.html { render :edit }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    @app.destroy
    respond_to do |format|
      format.html do
        redirect_to apps_url,
                    notice: 'App was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def scrape
    # url = 'https://slack.com/apps/'
    url = 'https://slack.com/apps/category/At0G5YTKU2-analytics'
    response = AppsSpider.process(url)
    if response[:status] == :completed && response[:error].nil?
      flash.now[:notice] = 'Successfully scraped url'
    else
      flash.now[:alert] = response[:error]
    end
  rescue StandardError => e
    flash.now[:alert] = "Error: #{e}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_app
    @app = App.find(params[:id])
  end

  def app_params
    params.require(:app).permit(
      :name, :description, :email, :help_link, :categories
    )
  end
end
