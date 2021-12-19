# frozen_string_literal: true

require 'rails_helper'
describe PeopleController do
  describe 'create' do
    it 'should create' do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, params: { person: { name: 'Pavel' } }
      response.should redirect_to people_path
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
      person = FactoryGirl.create(:person)
      patch :update, params: { id: person.id, person: { name: 'Pavel' } }
      response.should redirect_to people_path
    end
    it 'not working update' do
      person = FactoryGirl.create(:person)
      patch :update, params: { id: person.id, person: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  describe 'test' do
    it 'test factory' do
      man = FactoryGirl.create(:person)
    end
  end
end