require 'rails_helper'

describe TasksController do


  let!(:user) { FactoryGirl.create(:user, :programmer) }
  let!(:task) { FactoryGirl.create(:task, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'renders index template' do
      get :index
      expect(response).to render_template(:index)
    end

    context 'without assigned tasks' do
      it 'assigns valid @tasks' do
        get :index
        expect(assigns(:tasks)).not_to be_empty
      end
    end

    context 'with assigned tasks' do
      let!(:task1) { FactoryGirl.create(:task, user: user) }

      it 'assigns valid @tasks' do
        get :index
        expect(assigns(:tasks)).to match_array([task, task1])
      end
    end
  end

  describe 'GET #new' do
    it 'renders new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before do
        ManagerMock.any_instance.stubs(:result).returns(true)
      end

      it 'redirects to project index' do
        post :create, task: FactoryGirl.attributes_for(:task)
        expect(response).to be_success
      end
    end

    context 'with invalid params' do
      before do
        ManagerMock.any_instance.stubs(:item).returns(task)
      end

      it 'returns 422' do
        post :create, task: FactoryGirl.attributes_for(:task)
        expect(response.status).to eq(422)
      end
    end
  end


  describe 'PATCH #update' do
    context 'with valid params' do
      before do
        ManagerMock.any_instance.stubs(:result).returns(true)
      end

      it 'redirects to project index' do
        patch :update, id: task, task: FactoryGirl.attributes_for(:task)
        expect(response).to be_success
      end
    end

    context 'with invalid params' do
      before do
        ManagerMock.any_instance.stubs(:item).returns(task)
      end

      it 'returns 422' do
        patch :update, id: task, task: FactoryGirl.attributes_for(:task)
        expect(response.status).to eq(422)
      end
    end
  end



  describe 'GET #find' do
    it 'has success response' do
      get :find, name: 'test'
      expect(response).to be_success
    end
  end

end
