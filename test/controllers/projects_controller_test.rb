require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
