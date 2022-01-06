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
    notes.each do |note|
      @note_expenses.append(note) unless note.text.strip.empty?
    end
  end

  # POST /expenses or /expenses.json
  def create
    param = params_to_create
    status = params[:expense].require(:status) == '1'
    @expense = Expense.new(name: param[0], text:  param[1],
                           time: param[4], category_id:  param[3], status: status, summ:  param[2])
    redirect_to expenses_path(params.require(:format)) if @expense.save
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    @expense = Expense.find(params.require(:format))
    @peoples_id = Expense.find(params.require(:format)).category_id
    redirect_to expenses_path(@peoples_id) if update_atr(@expense)
  rescue StandardError
    redirect_to edit_expense_path(params.require(:format))
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense = Expense.find(params.require(:format))
    @peoples_id = Expense.find(params.require(:format)).category_id
    redirect_to expenses_path(@peoples_id) if @expense.destroy
  end

  def params_to_create
    id = params.require(:format)
    name = params[:expense].require(:name)
    text = params[:expense][:text]
    sum = params[:expense].require(:summa)
    time = params[:expense].require(:date)
    [name, text, sum, id, time]
  rescue StandardError
    redirect_to new_expense_path(id)
  end

  def update_atr(expense)
    name = params[:expense].require(:name)
    sum = params[:expense].require(:summa)
    time = params[:expense].require(:date)
    status = params[:expense].require(:status)
    text = params[:expense][:text]
    status = status == '1'
    expense.update_attribute(:name, name)
    expense.update_attribute(:text, text)
    expense.update_attribute(:status, status)
    expense.update_attribute(:summ, sum)
    expense.update_attribute(:time, time)
  end
end
