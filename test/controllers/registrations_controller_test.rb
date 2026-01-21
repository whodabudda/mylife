# In test/controllers/registrations_controller_test.rb
require 'test_helper'

class Devise::RegistrationsControllerTest < ActionController::TestCase
  include Devise::Test::IntegrationHelpers 

#  setup do 
#    @request.env['devise.mapping'] = Devise.mappings[:duser]
#    assert_equal(0,Duser.count, "Number of Dusers before create is zero") 
#    post :create, params: { duser: { email: 'one@nomail.com',  password: 'password123', username: 'testuser'} }
#    assert_response :redirect
#    assert_redirected_to root_path
#    puts flash[:notice]
#  end
  test "should create a new system_user Duser record " do
    #FactoryBot.config.factory_bot.reject_primary_key_attributes = false
    assert_equal(0,Duser.count, "Database should have no Duser record" )
    FactoryBot.create(:duser, :with_specific_id, specific_id: Duser.system_user)
    assert_equal(1,Duser.find(1).id, "Database should have 1 Duser record with id of 1" )
    #FactoryBot.config.factory_bot.reject_primary_key_attributes = true
    #@duser = dusers(:one)
    #sign_in dusers(@duser)
    #assert_match /charted/, flash[:notice]
  end
  test "Duser model prevents non-unique email or username" do
    FactoryBot.create(:duser, :not_unique)
    assert_equal(1,Duser.count, "Database should have 1 Duser record" )
    @dusernew = Duser.first.dup
    @dusernew.save
    assert_not @dusernew.valid?, "Duser should not be valid"
    assert_equal ["has already been taken"], @dusernew.errors[:email], "Should have uniqueness error for email"
    assert_equal ["has already been taken"], @dusernew.errors[:username], "Should have uniqueness error for username"
    assert_equal(1,Duser.count, "Database should have 1 Duser record" )
  end
  #this test included in case raw sql is used somewhere to add a duser
  test "Duser database table should raise unique constraint error " do
    FactoryBot.create(:duser)
    assert_equal(1,Duser.count, "Database should have 1 Duser record" )
    @dusernew = Duser.first.dup
    exception = assert_raises(ActiveRecord::RecordNotUnique) do
      @dusernew.save(validate: false)
    end
    assert_equal(1,Duser.count, "Database should have 1 Duser record" )
    # uncomment if you want to see the error from MySQL.  It will make the test fail, however
    #assert_equal("message", exception.message)
  end
#  test "username cannot be null " do
#   @duser = Duser.all.first 
#   @duser.username = nil
#   @duser.save
#  end
end
