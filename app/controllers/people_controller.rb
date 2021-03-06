# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :set_person, only: %i[show edit update destroy]
  # GET /people or /people.json
  def index
    @people = current_user.people
    Person.create(name: 'ME', user_id: current_user.id).save if current_user.people.count.zero?
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
    @person = Person.create(name: person_params[:name], user_id: person_params[:user_id])
    respond_to do |format|
      if @person.save
        format.html { redirect_to people_path, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    redirect_to @person.update(name: person_params[:name]) ? people_path : edit_person_path(@person.id)
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

  def render_not_found(_exception)
    redirect_to notfound_path
  end

  def person_params
    data = params.require(:person).permit(:name)
    user_id = current_user.id
    { name: data[:name], user_id: user_id }
  end
end
