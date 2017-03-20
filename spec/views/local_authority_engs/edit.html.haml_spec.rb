require 'rails_helper'

RSpec.describe "local_authority_engs/edit", type: :view do
  before(:each) do
    @local_authority_eng = assign(:local_authority_eng, LocalAuthorityEng.create!(
      :name => "MyString",
      :start_date => "MyString",
      :end_date => "MyString",
      :local_authority_type => "MyString",
      :code => "MyString"
    ))
  end

  it "renders the edit local_authority_eng form" do
    render

    assert_select "form[action=?][method=?]", local_authority_eng_path(@local_authority_eng), "post" do

      assert_select "input#local_authority_eng_name[name=?]", "local_authority_eng[name]"

      assert_select "input#local_authority_eng_start_date[name=?]", "local_authority_eng[start_date]"

      assert_select "input#local_authority_eng_end_date[name=?]", "local_authority_eng[end_date]"

      assert_select "input#local_authority_eng_local_authority_type[name=?]", "local_authority_eng[local_authority_type]"

      assert_select "input#local_authority_eng_code[name=?]", "local_authority_eng[code]"
    end
  end
end
