require 'rails_helper'

RSpec.describe Admin::VotesController, type: :controller do
  let(:user) { create(:user, :admin) }

  allow_user_to(:manage, Vote)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a vote grid' do
      create(:vote, title: 'Second vote')
      create(:vote, title: 'First vote')
      create(:vote, title: 'Third vote')

      get(:index)
      response.status.should eq(200)
      assigns(:votes_grid).should be_present
    end
  end

  describe 'GET #show' do
    it 'assigns given vote as @vote' do
      vote = create(:vote)

      get(:show, id: vote.to_param)
      assigns(:vote).should eq(vote)
      assigns(:audit_grid).should be_present
    end
  end

  describe 'GET #edit' do
    it 'assigns given vote as @vote' do
      vote = create(:vote)

      get(:edit, id: vote.to_param)
      assigns(:vote).should eq(vote)
    end
  end

  describe 'GET #new' do
    it 'assigns a new vote as @vote' do
      get(:new)
      assigns(:vote).instance_of?(Vote).should be_truthy
      assigns(:vote).new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      option_attr = { '12345678': { title: 'Joost' } }
      attributes = { title: 'Ordförande',
                     open: true,
                     vote_options_attributes: option_attr }

      lambda do
        post :create, vote: attributes
      end.should change(Vote, :count).by(1)

      response.should redirect_to(edit_admin_vote_path(Vote.last))
      Vote.last.vote_options.map(&:title).should eq(['Joost'])
    end

    it 'invalid parameters' do
      lambda do
        post :create, vote: { title: '' }
      end.should change(Vote, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      vote = create(:vote, title: 'A Bad Title')

      patch :update, id: vote.to_param, vote: { title: 'A Good Title' }
      vote.reload

      response.should redirect_to(edit_admin_vote_path(vote))
    end

    it 'invalid parameters' do
      vote = create(:vote, title: 'A Bad Title')

      patch :update, id: vote.to_param, vote: { title: '' }
      vote.reload

      response.status.should eq(422)
      response.should render_template(:edit)
      vote.title.should eq('A Bad Title')
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      vote = create(:vote)

      lambda do
        delete :destroy, id: vote.to_param
      end.should change(Vote, :count).by(-1)

      response.should redirect_to(admin_votes_path)
    end
  end

  describe 'PATCH #open' do
    it 'opens the vote' do
      vote = create(:vote, open: false)

      patch(:open, id: vote)

      response.should redirect_to(admin_votes_path)
      flash[:notice].should eq(I18n.t('vote.made_open'))
      vote.reload
      vote.open.should be_truthy
    end

    it 'cannot open the vote' do
      create(:vote, open: true)
      vote = create(:vote, open: false)

      patch(:open, id: vote)

      response.should redirect_to(admin_votes_path)
      flash[:alert].should eq(I18n.t('vote.open_failed'))
      vote.reload
      vote.open.should be_falsey
    end
  end

  describe 'PATCH #close' do
    it 'closes the vote' do
      vote = create(:vote, open: true)

      patch(:close, id: vote)

      response.should redirect_to(admin_votes_path)
      flash[:notice].should eq(I18n.t('vote.made_closed'))
      vote.reload
      vote.open.should be_falsey
    end
  end
end
