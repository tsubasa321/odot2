require 'spec_helper'

describe User do
  let(:valid_attributes) {
    {
      first_name: "Jason",
      last_name: "Seifer",
      email: "jason@teamtreehouse.com",
      password: "treehouse1234",
      password_confirmation: "treehouse1234"
    }
  }

  context "relationships" do
    it { should have_many(:todo_lists) }
  end

  context "validations" do
    let(:user) { User.new(valid_attributes) }

    before do
      User.create(valid_attributes)
    end

    it "requires an email" do 
      expect(user).to validate_presence_of(:email)
    end

    it "requires a unique email" do
      expect(user).to validate_uniqueness_of(:email)
    end

    it "requires a unique email (case insensitive)" do
      user.email = "JASON@TEAMTREEHOUSE.COM"
      expect(user).to validate_uniqueness_of(:email)
    end

    it "requires the email address to look like an email" do
      user.email = "jason"
      expect(user).to_not be_valid
    end
    
  end

  describe "#downcase_email" do
    it "makes the email attribute lower case" do
      user = User.new(valid_attributes.merge(email: "JASON@TEAMTREEHOUSE.COM"))
      expect{ user.downcase_email }.to change{ user.email }.
        from("JASON@TEAMTREEHOUSE.COM").
        to("jason@teamtreehouse.com")
    end

    it "downcases an email before saving" do
      user = User.new(valid_attributes)
      user.email = "MIKE@TEAMTREEHOUSE.COM"
      expect(user.save).to be_true
      expect(user.email).to eq("mike@teamtreehouse.com")
    end

    describe "password reset" do
      let!(:user) { create(:user) }
      
      it "changes password_reset_token attribute for user" do
        expect{user.generate_password_reset_token!}.to change{user.password_reset_token}
      end 
    end
  end
end
