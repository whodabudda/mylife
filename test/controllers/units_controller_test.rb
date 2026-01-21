require 'test_helper'

#class UnitsControllerTest < ActionController::TestCase
class UnitsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers 
  # Your predefined array of strings
  system_units = {'millimeters' => 'mm', 'Absolute Value' => 'number', 'One to Ten Scale' => '1<>10'}
  duser_units = {'volts' => 'v', 'calories' => 'cal', 'hours' => 'hrs'}
  setup do
    puts ">>>>>Executed the setup function"
  end

  test "should get index of only the users own and system-owned units" do
    #create 2 dusers, and sign one of them in
   @duser = FactoryBot.create(:duser)
   @duser2 = FactoryBot.create(:duser)
   sign_in @duser
   authrecs = []
   unauthrecs = []
   #
   # create a set of 3 new Units for each duser, including the system_user, storing resulting Unit
   # object in an array of authorized and unauthorized records.  The objects created for duser2
   # the signed-in duser should not be able to see.
   #
   duser_units.each do |k,v| 
     authrecs << FactoryBot.create(:unit , name: k, displ_name: v , duser_id: @duser.id)
   end
   duser_units.each do |k,v| 
     unauthrecs << FactoryBot.create(:unit , name: k, displ_name: v , duser_id: @duser2.id)
   end
   system_units.each do |k,v| 
     authrecs << FactoryBot.create(:unit , name: k, displ_name: v ,  duser_id: 1)
   end
    #puts "authrecs: #{authrecs.length}"
    #puts "unauthrecs: #{unauthrecs.length}"
    #
    # call the UnitsController#index action
    #
    get units_path 
    assert_response :success
    #
    #the ids in the returned units should match the ids in the authorized units
    assert (assigns(:units).map(&:id) - authrecs.map(&:id)).length == 0
    #
    # the ids in the returned units should contain none of the ids from the unauthorized units
    assert (assigns(:units).map(&:id) - unauthrecs.map(&:id)) == assigns(:units).map(&:id) 
    assert Unit.all.count == 9
  end

  test "should only create/update units that belong to current_duser" do
    @duser = FactoryBot.create(:duser)
    sign_in @duser
    #get a non-persisted Unit
    get new_unit_path 
    assert_response :success
    @unit = assigns(:unit)
    #should not yet have an id
    assert @unit.id.nil?
    #duser_id should have been assigned to the current_duser.id in the controller 
    assert_equal @unit.duser_id, @duser.id
    #fill in some fields
    @unit.displ_name = 'mm'
    @unit.name = 'millimeters'
    #save the new Unit. 
    assert_difference('Unit.count') do
      post units_path, params: { unit: { displ_name: @unit.displ_name, duser_id: @unit.duser_id, name: @unit.name }}
    end
    assert_response :redirect
    #change the duser id to one that doesn't own this Unit, and isn't the current_duser.id in the session
    #will fail to create a new Unit
    post units_path, params:  { unit: { displ_name: @unit.displ_name, duser_id: 9000, name: @unit.name }}
    #if the flash notice has the word 'access', then an access error was raised
    assert_match  /access/,flash[:notice]
    assert_response :redirect
    #get the unit so we can use the id in the patch call
    @unit = Unit.last
    #change the last name by 2 characters and test
    assert_difference('Unit.last.name.length',2) do
      patch unit_path(@unit), params: { unit: { name: 'New unit name' }}
    end
    #finally, try to update the Unit with a changed duser_id. Should fail with NotAuthorized
    patch unit_path(@unit), params: { unit: { duser_id: 9000, name: 'Newer unit name' }}
    assert_match  /access/,flash[:notice]
    assert_response :redirect
  end
  test "should not allow a unit name to be changed to an existing unit name" do
    @duser = FactoryBot.create(:duser)
    sign_in @duser

    #get a non-persisted Unit
    get new_unit_path 
    assert_response :success
    @unit = assigns(:unit)

    #should not yet have an id
    assert @unit.id.nil?

    #duser_id should have been assigned to the current_duser.id in the controller 
    assert_equal @unit.duser_id, @duser.id

    #fill in some fields
    @unit.displ_name = 'mm'
    @unit.name = 'millimeters'

    #save the new Unit
    assert_difference('Unit.count') do
      post units_path, params: { unit: { displ_name: @unit.displ_name, duser_id: @unit.duser_id, name: @unit.name }}
    end

    #fill in some fields
    @unit.displ_name = 'v'
    @unit.name = 'volts'

    #save the second Unit
    assert_difference('Unit.count') do
      post units_path, params: { unit: { displ_name: @unit.displ_name, duser_id: @unit.duser_id, name: @unit.name }}
    end
    #update the last saved unit to the name for the first saved unit.  Should raise an error.
    @unit = Unit.last
    #exception = assert_raises("ActiveRecord::RecordInvalid") do
    begin
      patch unit_path(@unit), params: { unit: { name: 'millimeters' }}
    rescue => e
      puts "Actual exception class: #{e.class}"
      raise e
    end
    #end
    #puts "The exception returned: " + exception.to_s
    @unit = assigns(:unit)
    #assert_match  /already/,flash[:notice]
    #assert_equal("message", exception.message)
    assert_equal ["has already been taken"], @unit.errors[:name], "already in use by you or system user"
#    assert_match  /access/,flash[:notice]
  end

  test "should destroy unit and any Metrics using the unit" do

    #sign in a duser and create some units
    @duser = FactoryBot.create(:duser)
    sign_in @duser
    @unit = nil
    duser_units.each do |k,v| 
      @unit = FactoryBot.create(:unit , name: k, displ_name: v , duser_id: @duser.id)
      FactoryBot.create(:metric, unit_id: @unit.id , duser_id: @duser.id)
    end

    assert_equal Unit.count, 3
    assert_equal Metric.count, 3

    #delete a unit. Should delete the metrics, reviews, and duser_metrics it is attached to  as well
    delete unit_path(@unit)

    assert_equal Unit.count, 2
    assert_equal Metric.count, 2

    assert_redirected_to units_path
  end
=begin
  test "should create unit" do
    assert_difference('Unit.count') do
      post :create, unit: { displ_name: @unit.displ_name, duser_id: @unit.duser_id, name: @unit.name }
    end

    assert_redirected_to unit_path(assigns(:unit))
  end

  test "should show unit" do
    get :show, id: @unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unit
    assert_response :success
  end

  test "should update unit" do
    patch :update, id: @unit, unit: { displ_name: @unit.displ_name, duser_id: @unit.duser_id, name: @unit.name }
    assert_redirected_to unit_path(assigns(:unit))
  end
=end
end
