# frozen_string_literal: true

class BuffersController < ApplicationController
  before_action :set_buffer, only: %i[show edit update destroy]

  # GET /buffers or /buffers.json
  def index
    @buffers = Buffer.all
  end

  # GET /buffers/1 or /buffers/1.json
  def show; end

  # GET /buffers/new
  def new
    @buffer = Buffer.new
  end

  # GET /buffers/1/edit
  def edit; end

  # POST /buffers or /buffers.json
  def create
    @buffer = Buffer.new(buffer_params)

    respond_to do |format|
      if @buffer.save
        format.html { redirect_to @buffer, notice: 'Buffer was successfully created.' }
        format.json { render :show, status: :created, location: @buffer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @buffer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buffers/1 or /buffers/1.json
  def update
    respond_to do |format|
      if @buffer.update(buffer_params)
        format.html { redirect_to @buffer, notice: 'Buffer was successfully updated.' }
        format.json { render :show, status: :ok, location: @buffer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @buffer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buffers/1 or /buffers/1.json
  def destroy
    @buffer.destroy
    respond_to do |format|
      format.html { redirect_to buffers_url, notice: 'Buffer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_buffer
    @buffer = Buffer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def buffer_params
    params.fetch(:buffer, {})
  end
end
