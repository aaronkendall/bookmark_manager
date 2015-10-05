require_relative '../spec_helper'

feature 'User sign up' do

  before(:each) do
    @user = build(:user)
  end

  def sign_up(type)
    visit '/users/new'
    fill_in :email, with: type.email
    fill_in :password, with: type.password
    fill_in :password_confirmation, with: type.password_confirmation
    click_button 'Sign up'
  end

  scenario 'I can sign up as an new user' do
    expect { sign_up(@user) }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'requires a matching confirmation password' do
    user_no_pass = build(:user, password_confirmation: 'wrong')
    expect { sign_up(user_no_pass) }.not_to change(User, :count)
  end

  scenario 'with a password that does not match' do
    user_no_pass = build(:user, password_confirmation: 'wrong')
    expect { sign_up(user_no_pass) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'user cannot sign up without entering an email' do
    user_bad_email = build(:user, email: nil)
    expect { sign_up(user_bad_email) }.not_to change(User, :count)
  end

  scenario 'I cannot sign up with an existing email' do
    sign_up(@user)
    expect{ sign_up(@user) }.not_to change(User, :count)
    expect(page).to have_content('Email is already taken')
  end

end
