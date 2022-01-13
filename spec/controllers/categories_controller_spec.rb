# frozen_string_literal: true

require 'rails_helper'

describe CategoriesController do
  describe 'index' do
    it 'find cats' do
      category = FactoryGirl.create(:category)
      person = FactoryGirl.create(:person)
      buffer = FactoryGirl.create(:buffer, category_id: category.id, person_id: person.id)
      get :index, params: { people_id: person.id }
    end
    it 'not working index' do
      category = FactoryGirl.create(:category)
      person = FactoryGirl.create(:person)
      buffer = FactoryGirl.create(:buffer, category_id: category.id, person_id: person.id)
      get :index, params: { people_id: person.id + 1 }
      response.should redirect_to notfound_path
    end
  end
  describe 'edit' do
    it 'edit' do
      category = FactoryGirl.create(:category)
      person = FactoryGirl.create(:person)
      buffer = FactoryGirl.create(:buffer, category_id: category.id, person_id: person.id)
      get :edit, params: { format: category.id }
    end
    it 'not working edit' do
      category = FactoryGirl.create(:category)
      person = FactoryGirl.create(:person)
      buffer = FactoryGirl.create(:buffer, category_id: category.id, person_id: person.id)
      get :edit, params: { format: category.id + 1 }
      response.should redirect_to notfound_path
    end
  end
  describe 'create' do
    it 'create category' do
      user = FactoryGirl.create(:user)
      person = FactoryGirl.create(:person)
      category = FactoryGirl.create(:category)
      sign_in user
      post :create, params: { category: { name: category.name, status: 1, for_all: 1 }, format: person.id }
      response.should redirect_to categories_path(person.id)
    end
    it 'not working create action' do
      user = FactoryGirl.create(:user)
      person = FactoryGirl.create(:person)
      sign_in user
      post :create, params: { category: { name: '', status: 1, for_all: 1 }, format: person.id }
      response.should redirect_to new_category_path(person.id)
    end
  end
  describe 'update' do
    it 'update category' do
      user = FactoryGirl.create(:user)
      category = FactoryGirl.create(:category)
      person = FactoryGirl.create(:person)
      buffer = FactoryGirl.create(:buffer, category_id: category.id, person_id: person.id)
      sign_in user
      patch :update, params: { format: category.id, category: { name: 'Pavel', for_all: 1, status: 1 } }
      response.should redirect_to categories_path(person.id)
    end
    it 'not working update category' do
      user = FactoryGirl.create(:user)
      category = FactoryGirl.create(:category)
      person = FactoryGirl.create(:person)
      buffer = FactoryGirl.create(:buffer, category_id: category.id, person_id: person.id)
      sign_in user
      patch :update, params: { format: category.id, category: { name: '', for_all: 1, status: 1 } }
      response.should redirect_to edit_category_path(category.id)
    end
  end
  describe 'delete' do
    it 'delete category' do
      category = FactoryGirl.create(:category)
      person = FactoryGirl.create(:person)
      buffer = FactoryGirl.create(:buffer, category_id: category.id, person_id: person.id)
      delete :destroy, params: { format: category.id }
    end
  end
end
