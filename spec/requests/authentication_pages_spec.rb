require 'spec_helper'

describe "Authentication" do

  subject { page }
  
  describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.name) }

      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }

      it { should_not have_link('Sign in', href: signin_path) }

   end
   
   describe "authorization" do
    
      describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
        describe "in the Users controller" do
          
          describe "visiting the following page" do
            before { visit following_user_path(user) }
            it { should have_selector('title', text: 'Sign in') }
          end

          describe "visiting the followers page" do
            before { visit followers_user_path(user) }
            it { should have_selector('title', text: 'Sign in') }
          end
        end
        
        describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }          
        end
      end
        
      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before do
            micropost = FactoryGirl.create(:micropost)
            delete micropost_path(micropost)
          end
          specify { response.should redirect_to(signin_path) }
        end
      end
    end  
  end
end
