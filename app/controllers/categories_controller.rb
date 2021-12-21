# frozen_string_literal: true

class CategoriesController < ApplicationController
  # GET /categories or /categories.json
  def index
    if Category.count.zero?
      Buffer.create(category_id: 1, person_id: params.require(:people_id)).save(validate: false)
      Category.new(name: 'expenses', status: false).save(validate: false)
    end
    @categories = Person.find(params.require(:people_id)).categories.all
  end

  def days_in_month(month, year = Time.now.year)
    days_in_month = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    return 29 if month == 2 && Date.gregorian_leap?(year)

    days_in_month[month]
  end

  # GET /categories/1 or /categories/1.json
  def show; end

  # GET /categories/new
  def new
    @people_id = current_user.people.all
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @person_id = Buffer.find_by(category_id: params.require(:format)).person_id
  end

  # POST /categories or /categories.json
  def create
    name = params[:category].permit(:name)[:name]
    if name != ''
      status = params[:category].require(:status) == '1'
      if params[:category].require(:for_all) == '1'
        all_people = current_user.people
        all_people.each { |a| Buffer.create(category_id: Category.last.id + 1, person_id: a.id).save(validate: false) }
      else
        Buffer.create(category_id: Category.last.id + 1, person_id: params.require(:format)).save(validate: false)
      end
      @category = Category.new(name: params[:category].require(:name), status: status)
      redirect_to categories_path(params.require(:format)) if @category.save(validate: false)
    else
      redirect_to new_category_path(params.require(:format))
    end
  end

  def statistics; end

  def grafik
    category_id = params[:category].require(:category_id).drop(1)
    data = {}
    data_expenses = {}
    @names_expenses = []
    @names_of_income = []
    @names = []
    category_id.each do |i|
      if Category.find(i).status
        @names_expenses.append(Category.find(i).name)
      else
        @names_of_income.append(Category.find(i).name) unless Category.find(i).status
      end
      Category.find(i).expenses.each do |a|
        if Category.find(i).status
          @names.append(a.name)
          time = "#{a.time.month}-#{a.time.day}"
          if data[time].nil?
            data[time] = a.summ

          else
            data[time] += a.summ
          end
        else
          unless Category.find(i).status
            @names.append(a.name)
            time = "#{a.time.month}-#{a.time.day}"
            if data_expenses[time].nil?
              data_expenses[time] = a.summ
            else
              data_expenses[time] += a.summ
            end
          end
        end
      end
    end
    gon.data = data
    gon.space = data_expenses
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    target_category_id = params.require(:format)
    buffer = Buffer.find_by(category_id: target_category_id)
    @target_person_id = buffer.person_id
    target_category = Category.find(target_category_id)
    name = params[:category].permit(:name)[:name]
    if name != ''
      if params[:category].require(:for_all) == '1'
        all_people = current_user.people
        all_people.each { |a| Buffer.create(category_id: Category.last.id + 1, person_id: a.id).save(validate: false) }
      else
        Buffer.create(category_id: Category.last.id + 1, person_id: params.require(:format)).save(validate: false)
      end
      status = if (status = '1')
                 true
               else
                 false
               end
      target_category.update_attribute('name', name) && target_category.update_attribute('status', status)
      redirect_to(categories_path(@target_person_id))
    else
      redirect_to edit_category_path(target_category_id)
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    target = Buffer.find_by(category_id: params.require(:format)).person_id
    redirect_to categories_path(target) if Category.find(params.require(:format)).destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  # Only allow a list of trusted parameters through.
  def category_params
    params.fetch(:category, {})
  end
end
