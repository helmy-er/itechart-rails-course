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
    name = params[:expense].permit(:name)[:name]
    text = params[:expense].permit(:text)[:text]
    sum = params[:expense].permit(:summa)[:summa]
    time = params[:expense].permit(:date)[:date]
    if name != '' && sum != '' && time != ''
      status = params[:expense].require(:status) == '1'
      @expense = Expense.new(name: name, text: text,
                             time: time, category_id: params.require(:format), status: status, summ: sum)
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
      if @expense.update_attribute('name',
                                   name) && @expense.update_attribute('text',
                                                                      text) && @expense.update_attribute('status',
                                                                                                         status) && @expense.update_attribute(
                                                                                                           'summ', summ
                                                                                                         ) && @expense.update_attribute(
                                                                                                           'time', time
                                                                                                         )
        redirect_to expenses_path(@peoples_id)
      end
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
end
