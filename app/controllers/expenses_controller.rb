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
    @id = Expense.find(params.require(:format)).category_id
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
    id = params.require(:format)
    data = params[:expense].require(%i[name summa date])
    text = params[:expense][:text]
    status = params[:expense].require(:status) == '1'
    @expense = Expense.new(name: data[0], text:  text,
                           time: data[2], category_id:  id, status: status, summ:  data[1])
    redirect_to expenses_path(params.require(:format)) if @expense.save
  rescue StandardError
    redirect_to new_expense_path(id)
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    peoples_id = Expense.find(params.require(:format)).category_id
    redirect_to expenses_path(peoples_id) if update_atr(Expense.find(params.require(:format)))
  rescue StandardError
    redirect_to edit_expense_path(params.require(:format))
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    expense = Expense.find(params.require(:format))
    peoples_id = Expense.find(params.require(:format)).category_id
    redirect_to expenses_path(peoples_id) if expense.destroy
  end

  def update_atr(expense)
    data = params[:expense].require(%i[name summa date])
    status = params[:expense].require(:status)
    text = params[:expense][:text]
    status = status == '1'
    expense.update_attribute(:name, data[0])
    expense.update_attribute(:text, text)
    expense.update_attribute(:status, status)
    expense.update_attribute(:summ, data[1])
    expense.update_attribute(:time, data[2])
  end
end
