# frozen_string_literal: true

class ExpensesController < ApplicationController
  # GET /expenses or /expenses.json
  def index
    target = Category.find(params.require(:people_id))
    @expenses = target.expenses.all
  end

  # GET /expenses/1 or /expenses/1.json
  def show; end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit; end

  # POST /expenses or /expenses.json
  def create
    param = get_params_to_create
    if param[0] != '' && param[2] != '' && param[4] != ''
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
    name = params[:expense].permit(:name)[:name]
    text = params[:expense].permit(:text)[:text]
    status = params[:expense].permit(:status)[:status]
    summ = params[:expense].permit(:summa)[:summa]
    time = params[:expense].permit(:date)[:date]
    if name != '' && text != '' && summ != '' && time != ''
      status = status == '1'
      @expense = Expense.find(params.require(:format))
      @peoples_id = Expense.find(params.require(:format)).category_id
      redirect_to expenses_path(@peoples_id) if update_atr(@expense, [text, status, summ, time])
    else
      redirect_to edit_expense_path(params.require(:format))
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense = Expense.find(params.require(:format))
    @peoples_id = Expense.find(params.require(:format)).category_id
    redirect_to expenses_path(@peoples_id) if @expense.destroy
  end

  def get_params_to_create
    id = params.require(:format)
    name = params[:expense].permit(:name)[:name]
    text = params[:expense].permit(:text)[:text]
    sum = params[:expense].permit(:summa)[:summa]
    time = params[:expense].permit(:date)[:date]
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
