# frozen_string_literal: true

require 'rails_helper'

describe ExpensesController do
  describe 'index' do
    it 'should find expenses' do
      category = FactoryGirl.create(:category)
      person = FactoryGirl.create(:person)
      buffer = FactoryGirl.create(:buffer, category_id: category.id, person_id: person.id)
      get :index, params: { people_id: category.id }
    end
    it 'not working expenses' do
      category = FactoryGirl.create(:category)
      person = FactoryGirl.create(:person)
      buffer = FactoryGirl.create(:buffer, category_id: category.id, person_id: person.id)
      get :index, params: { people_id: category.id + 1 }
      response.should redirect_to notfound_path
    end
  end
  describe 'create' do
    it 'create new expenses' do
      expense = FactoryGirl.create(:expense)
      category = FactoryGirl.create(:category)
      post :create,
           params: { format: category.id,
                     expense: { name: 'Pavel', text: 'test', summ: '122', time: '2021-12-03', status: 1 } }
      response.should redirect_to(expenses_path(category.id))
    end
    it 'not working create action' do
      expense = FactoryGirl.create(:expense)
      category = FactoryGirl.create(:category)
      post :create,
           params: { format: category.id,
                     expense: { name: 'Pavel', text: '', summ: '', time: '2021-12-03', status: 1 } }
      response.should redirect_to new_expense_path(category.id)
    end
  end
  describe 'update' do
    it 'update expense' do
      expense = FactoryGirl.create(:expense)
      patch :update,
            params: { format: expense.id,
                      expense: { name: 'Pavel', text: 'asd', summ: '122', time: '2021-01-01', status: 1 } }
      response.should redirect_to(expenses_path(expense.category_id))
    end
    it 'not working update action' do
      expense = FactoryGirl.create(:expense)
      patch :update,
            params: { format: expense.id,
                      expense: { name: nil, text: nil, summ: '122', time: '2021-12-03', status: 1 } }
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
  describe 'notes' do
    it 'notes' do
      category = FactoryGirl.create(:category)
      expense = FactoryGirl.create(:expense, category_id: category.id)
      get :notes, params: { people_id: category.id }
    end
  end
end
