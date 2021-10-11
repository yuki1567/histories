module SignInSupport
  def sign_in(admin)
    visit new_user_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: admin.password
    find('input[name="commit"]').click
    expect(current_path).to eq(root_path)
  end
end
