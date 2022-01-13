# frozen_string_literal: true

require 'rails_helper'
describe PeopleController do
  describe 'index' do
    it 'should find people' do
      sign_in  FactoryGirl.create(:user)
      get :index
    end
    it 'not working index' do
      get :index
      response.should redirect_to notfound_path
    end
  end
  describe 'create' do
    it 'should create' do
      sign_in  FactoryGirl.create(:user)
      post :create, params: { person: { name: 'Pavel' } }
      response.should redirect_to people_path
    end
    it 'should not create' do
      sign_in  FactoryGirl.create(:user)
      post :create, params: { person: { name: '' } }
      expect(response).to have_http_status(422)
    end
  end
  describe 'delete' do
    it 'delete person' do
      person = FactoryGirl.create(:person)
      delete :destroy, params: { id: person.id }
      response.should redirect_to people_path
    end
  end
  describe 'update' do
    it 'update person' do
      sign_in  FactoryGirl.create(:user)
      person = FactoryGirl.create(:person)
      patch :update, params: { id: person.id, person: { name: 'Pavel' } }
      response.should redirect_to people_path
    end
    it 'not working update' do
      sign_in  FactoryGirl.create(:user)
      person = FactoryGirl.create(:person)
      patch :update, params: { id: person.id, person: { name: '' } }
      response.should redirect_to edit_person_path(person.id)
    end
  end
end
