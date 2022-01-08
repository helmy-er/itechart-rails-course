# frozen_string_literal: true

class CategoriesController < ApplicationController
  # GET /categories or /categories.json
  def index
    if Category.count.zero?
      Category.new(name: 'expenses', status: false).save
      Buffer.create(category_id: Category.last, person_id: params.require(:people_id)).save
    end
    @categories = Person.find(params.require(:people_id)).categories.all
  rescue ActiveRecord::RecordNotFound
    redirect_to notfound_path
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
  rescue NoMethodError
    redirect_to notfound_path
  end

  def notfound; end

  # POST /categories or /categories.json
  def create
    status = params[:category].require(:status) == '1'
    category = Category.new(name: params[:category].require(:name), status: status)
    if category.save
      if params[:category].require(:for_all) == '1'
        all_people = current_user.people
        all_people.each { |a| Buffer.create(category_id: Category.last.id, person_id: a.id).save }
      else
        Buffer.create(category_id: Category.last.id, person_id: params.require(:format)).save
      end
      redirect_to categories_path(params.require(:format))
    else
      redirect_to new_category_path(params.require(:format))
    end
  rescue StandardError
    redirect_to new_category_path(params.require(:format))
  end

  def statistics; end

  def grafik
    category_id = params[:category].require(:category_id).drop(1)
    # hash with income
    data = {}
    # hash with expenses
    data_expenses = {}
    # names of categories
    @names = get_cat_names(category_id)
    # names of expenses that were used
    @expenses_names = []
    category_id.each do |i|
      Category.find(i).expenses.each do |a|
        if Category.find(i).status
          @expenses_names.append(a.name)
          # create date like 11-2  month - day
          time = "#{a.time.month}-#{a.time.day}"
          # filling  the hash with money
          if data[time].nil?
            data[time] = a.summ
          else
            # if there is money on the checked   day, they add up
            data[time] += a.summ
          end
        else
          unless Category.find(i).status
            @expenses_names.append(a.name)
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
    gon.data_income = data
    gon.date_expenses = data_expenses
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    target_category_id = params.require(:format)
    @target_person_id =  Buffer.find_by(category_id: target_category_id).person_id
    target_category = Category.find(target_category_id)
    name = params[:category].require(:name)
    Buffer.all.where(category_id: target_category_id).each(&:delete)
    if params[:category].require(:for_all) == '1'
      all_people = current_user.people
      all_people.each { |a| Buffer.create(category_id: target_category_id, person_id: a.id).save }
    else
      Buffer.create(category_id: target_category_id, person_id: @target_person_id).save
    end
    status = (status == '1')
    target_category.update(name: name, status: status)
    redirect_to(categories_path(@target_person_id))
  rescue StandardError
    redirect_to edit_category_path(params.require(:format))
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    target = Buffer.find_by(category_id: params.require(:format)).person_id
    redirect_to categories_path(target) if Category.find(params.require(:format)).destroy
  rescue NoMethodError
    redirect_to notfound_path
  end

  def get_cat_names(category_id)
    names_expenses = []
    names_of_income = []
    category_id.each do |id|
      if Category.find(id).status
        names_expenses.append(Category.find(id).name)
      else
        names_of_income.append(Category.find(id).name)
      end
    end
    [names_expenses, names_of_income]
  end
end
