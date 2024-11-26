class ActionController::IntegrationTest < ActionDispatch::IntegrationTest

  def warden
    request.env['warden']
  end

  def create_full_user
    @@user ||= begin
                 user = User.create!(
                   :email                 => 'fulluser@test.com',
                   :password              => '123456',
                   :password_confirmation => '123456'
                 )
                 @@user = user
                 user
               end
  end

  def create_and_signin_gauth_user
    create_full_user
    User.find_by(email: "fulluser@test.com").update(:gauth_enabled => 1) # force this off - unsure why sometimes it flicks on possible race condition
    visit new_user_session_path
    fill_in 'user_email', :with => 'fulluser@test.com'
    fill_in 'user_password', :with => '123456'
    click_button 'Log in'
  end

  def sign_in_as_user(user = nil)
    user ||= create_full_user
    resource_name = user.class.name.underscore
    visit send("new_#{resource_name}_session_path")
    fill_in "#{resource_name}_email", :with => user.email
    fill_in "#{resource_name}_password", :with => user.password
    click_button 'Log in'
  end
end
