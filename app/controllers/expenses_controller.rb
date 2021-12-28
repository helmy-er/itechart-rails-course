# frozen_string_literal: true

class ExpensesController < ApplicationController
  # GET /expenses or /expenses.json
  def index
    target = Category.find(params.require(:people_id))
    @expenses = target.expenses.all
    @people_id = Buffer.find_by(category_id: target).person_id
  end

  # GET /expenses/1 or /expenses/1.json
  def show; end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
    expense = params.require(:format)
    @id = Expense.find(expense).category_id
  rescue ActiveRecord::RecordNotFound
    redirect_to notfound_path
  end

  def notes
    target = Category.find(params.require(:people_id))
    @note_expenses = []
    notes = target.expenses.all
    notes.each do |a|
      @note_expenses.append(a) unless a.text.delete(' ').empty?
    end
  end

  # POST /expenses or /expenses.json
  def create
    param = get_params_to_create
    if param[0].present? && param[2].present? && param[4].present?
      status = params[:expense].require(:status) == '1'
      @expense = Expense.new(name: param[0], text:  param[1],
                             time: param[4], category_id:  param[3], status: status, summ:  param[2])
      redirect_to expenses_path(params.require(:format)) if @expense.save(validate: false)
    else
      redirect_to new_expense_path(params.require(:format))
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    name = params[:expense][:name]
    text = params[:expense][:text]
    status = params[:expense][:status]
    summ = params[:expense][:summa]
    time = params[:expense][:date]
    if name.present? && text.present? && summ.present? && time.present?
      status = status == '1'
      @expense = Expense.find(params.require(:format))
      @peoples_id = Expense.find(params.require(:format)).category_id
      redirect_to expenses_path(@peoples_id) if update_atr(@expense, [text, status, summ, time])
    else
      redirect_to edit_expense_path(params.require(:format))
    end
  rescue NoMethodError
    redirect_to notfound_path
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense = Expense.find(params.require(:format))
    @peoples_id = Expense.find(params.require(:format)).category_id
    redirect_to expenses_path(@peoples_id) if @expense.destroy
  end

  def get_params_to_create
    id = params.require(:format)
    name = params[:expense][:name]
    text = params[:expense][:text]
    sum = params[:expense][:summa]
    time = params[:expense][:date]
    [name, text, sum, id, time]
  end

  def update_atr(expense, atributes)
    @expense = expense
    @expense.update_attribute('name', atributes[0])
    @expense.update_attribute('text', atributes[1])
    @expense.update_attribute('status', atributes[2])
    @expense.update_attribute('summ', atributes[3])
    @expense.update_attribute('time', atributes[4])
  end
end
