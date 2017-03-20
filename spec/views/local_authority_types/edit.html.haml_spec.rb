require 'rails_helper'

RSpec.describe "local_authority_types/edit", type: :view do
  before(:each) do
    @local_authority_type = assign(:local_authority_type, LocalAuthorityType.create!(
      :local_authority_type => "MyString",
      :name => "MyString",
      :start_date => "MyString",
      :end_date => "MyString"
    ))
  end

  it "renders the edit local_authority_type form" do
    render

    assert_select "form[action=?][method=?]", local_authority_type_path(@local_authority_type), "post" do

      assert_select "input#local_authority_type_local_authority_type[name=?]", "local_authority_type[local_authority_type]"

      assert_select "input#local_authority_type_name[name=?]", "local_authority_type[name]"

      assert_select "input#local_authority_type_start_date[name=?]", "local_authority_type[start_date]"

      assert_select "input#local_authority_type_end_date[name=?]", "local_authority_type[end_date]"
    end
  end
end
