# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.new(email: 'josh@josh.com', password: 'password123')}

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe "is_password?" do
    it "is password works for a good password" do
       expect(user.is_password?('password123')).to be true
    end

    it "is password does not work for a bad password" do
       expect(user.is_password?('password')).to be false
    end
  end

  describe "reset_session_token!" do
    it 'resets the users session token' do
      user.valid?
      old_token = user.session_token
      user.reset_session_token!

      expect(user.session_token).to_not eq(old_token)
    end

    it 'returns the new session token' do
      expect(user.reset_session_token!).to eq(user.session_token)
    end
  end

  describe ".find_by_credentials" do
    before { user.save! }

    it 'returns the correct user' do 
      expect(User.find_by_credentials('josh@josh.com', 'password123')).to eq(user)
    end

    it 'does not work with bad information' do
      expect(User.find_by_credentials('josh@josh.com', 'password')).to eq(nil)
    end
  end
end
