# frozen_string_literal: true

require 'rails_helper'

describe ExpensesController do
  describe 'index' do
    it 'should find expenses' do
      caregory = FactoryGirl.create(:category)
      get  :index, params: { people_id: caregory.id }
    end
  end
  describe 'create' do
    it 'create new expenses' do
      post :create,
           params: { format: '4',
                     expense: { name: 'Pavel', text: 'test', summa: '122', date: '2021-12-03', status: 1 } }
      response.should redirect_to(expenses_path('4'))
    end
    it 'not working create action' do
      post :create,
           params: { format: '4', expense: { name: 'Pavel', text: '', summa: '', date: '2021-12-03', status: 1 } }
      response.should redirect_to new_expense_path('4')
    end
  end
  describe 'update' do
    it 'update expense' do
      expense = FactoryGirl.create(:expense)
      patch :update,
            params: { format: expense.id,
                      expense: { name: 'Pavel', text: 'asd', summa: '122', date: '2021-12-03', status: 1 } }
      response.should redirect_to(expenses_path(expense.category_id))
    end
    it 'not working update action' do
      expense = FactoryGirl.create(:expense)
      patch :update,
            params: { format: expense.id,
                      expense: { name: 'Pavel', text: nil, summa: '122', date: '2021-12-03', status: 1 } }
      response.should redirect_to(edit_expense_path(expense.id))
    end
  end
  describe 'delete' do
    it 'destroy expense ' do
      expense = FactoryGirl.create(:expense)
      delete :destroy, params: { format: expense.id }
      response.should redirect_to expenses_path(expense.category_id)
    end
  end
end
