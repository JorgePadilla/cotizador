require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client = clients(:one)
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get clients_url
    assert_response :success
  end

  test "should get show" do
    get client_url(@client)
    assert_response :success
  end

  test "should get new" do
    get new_client_url
    assert_response :success
  end

  test "should get edit" do
    get edit_client_url(@client)
    assert_response :success
  end

  test "should create client" do
    assert_difference("Client.count") do
      post clients_url, params: { client: { name: "New Client", rtn: "87654321", email: "client@example.com", address: "123 Main St", phone: "12345678" } }
    end
    # Get the actual client that was created
    new_client = Client.find_by(rtn: "87654321")
    assert_redirected_to client_url(new_client)
  end

  test "should update client" do
    patch client_url(@client), params: { client: { name: "Updated Client" } }
    assert_redirected_to client_url(@client)
  end

  test "should destroy client" do
    assert_difference("Client.count", -1) do
      delete client_url(@client)
    end
    assert_redirected_to clients_url
  end
end
