# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :set_person, only: %i[show edit update destroy]

  # GET /people or /people.json
  def index
    @people = current_user.people
    if current_user.people.count.zero?
      const_people = Person.create(name: 'ME', user_id: current_user.id)
      const_people.save
    end
  end

  # GET /people/1 or /people/1.json
  def show; end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit; end

  # POST /people or /people.json
  def create
    if params[:person].permit(:name)[:name] != ''
      @person = Person.create(name: params[:person].require(:name), user_id: current_user.id)
      respond_to do |format|
        if @person.save
          format.html { redirect_to people_path, notice: 'Person was successfully created.' }
          format.json { render :show, status: :created, location: @person }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @person.errors, status: :unprocessable_entity }
        end
      end

    else
      redirect_to new_person_path
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if params.require(:person).permit(:name)[:name] != ''
        if @person.update(person_params)
          format.html { redirect_to people_path, notice: 'Person was successfully updated.' }
          format.json { render :show, status: :ok, location: @person }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def person_params
    params.require(:person).permit(:name)
  end
end