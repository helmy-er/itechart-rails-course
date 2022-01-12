# frozen_string_literal: true

class ExpensesController < ApplicationController
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
  end

  def notes
    target = Category.find(params.require(:people_id))
    @note_expenses = []
    target.expenses.all.each { |note| @note_expenses.append(note) unless note.text.blank? }
  end

  # POST /expenses or /expenses.json
  def create
    id = params.require(:format)
    status = exp_prms[:status] == '1'
    @expense = Expense.new(name: exp_prms[:name], text: exp_prms[:text],
                           time: exp_prms[:date], category_id: id, status: status, summ: exp_prms[:summa])
    redirect_to @expense.save ? expenses_path(id) : new_expense_path(id)
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    expense = Expense.find(params.require(:format))
    status = exp_prms[:status] == '1'
    if expense.update(name: exp_prms[:name], status: status,
                      text: exp_prms[:text], time: exp_prms[:date], summ: exp_prms[:summa])
      redirect_to expenses_path(expense.category_id)
    else
      redirect_to edit_expense_path(params.require(:format))
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    expense = Expense.find(params.require(:format))
    redirect_to expenses_path(expense.category_id) if expense.destroy
  end

  private

  def render_not_found(_exception)
    redirect_to notfound_path
  end

  def exp_prms
    params.require(:expense).permit(:name, :summa, :date, :text, :status)
  end
end
