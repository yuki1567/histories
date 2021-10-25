module SignInSupport
  def sign_in(admin)
    visit new_user_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: admin.password
    click_button('ログイン')
    expect(current_path).to eq(root_path)
  end
end
