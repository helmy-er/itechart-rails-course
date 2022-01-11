# frozen_string_literal: true

class CategoriesController < ApplicationController
  # GET /categories or /categories.json

  def index
    people_id = params.require(:people_id)
    if Person.find(people_id).categories.count.zero?
      first_category = Category.new(name: 'expenses', status: false)
      first_category.save
      Buffer.create(category_id: first_category.id, person_id: people_id).save
    end
    @categories = Person.find(people_id).categories.all
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

  def notfound; end

  # POST /categories or /categories.json
  def create
    id = params.require(:format)
    status = cat_params[:status] == '1'
    category = Category.new(name: cat_params[:name], status: status)
    if category.save
      if cat_params[:for_all] == '1'
        current_user.people.each { |person| Buffer.create(category_id: category.id, person_id: person.id).save }
      else
        Buffer.create(category_id: category.id, person_id: id).save
      end
      redirect_to categories_path(id)
    else
      redirect_to new_category_path(id)
    end
  end

  def statistics; end

  def grafik
    category_id = params[:category].require(:category_id).drop(1)
    data_income = {}
    data_expenses = {}
    @names = get_cat_names(category_id)
    category_id.each do |id|
      Category.find(id).expenses.each do |expense|
        time = "#{expense.time.month}-#{expense.time.day}"
        if Category.find(id).status
          if data_income[time].nil?
            data_income[time] = expense.summ
          else
            data_income[time] += expense.summ
          end
        elsif data_expenses[time].nil?
          data_expenses[time] = expense.summ
        else
          data_expenses[time] += expense.summ
        end
      end
    end
    gon.data_income = data_income
    gon.date_expenses = data_expenses
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    id = params.require(:format)
    status = cat_params[:status] == '1'
    @target_person_id = Buffer.find_by(category_id: id).person_id
    if Category.find(id).update(name: cat_params[:name], status: status)
      Buffer.where(category_id: id).each(&:delete)
      if cat_params[:for_all] == '1'
        all_people = current_user.people
        all_people.each { |person| Buffer.create(category_id: id, person_id: person.id).save }
      else
        Buffer.create(category_id: id, person_id: @target_person_id).save
      end
      redirect_to(categories_path(@target_person_id))
    else
      redirect_to edit_category_path(id)
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    target = Buffer.find_by(category_id: params.require(:format)).person_id
    Buffer.where(category_id: params.require(:format)).each(&:delete)
    redirect_to categories_path(target) if Category.find(params.require(:format)).destroy
  end

  def get_cat_names(category_id)
    names_expenses = []
    names_of_income = []
    names_of_records = []
    category_id.each do |id|
      category = Category.find(id)
      if !category.status
        names_of_income.append(category.name)
      else
        names_expenses.append(category.name)
      end
      category.expenses.each { |expense| names_of_records.append(expense.name) }
    end
    [names_expenses, names_of_income, names_of_records]
  end
  unless config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound, NoMethodError, with: :render_not_found
  end

  private

  def render_not_found(_exception)
    redirect_to notfound_path
  end

  def cat_params
    params.require(:category).permit(:status, :name, :for_all)
  end
end
