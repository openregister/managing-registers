describe "managing registers", :type => :feature do
  before :each do
    create(:user)
    expect(User.count).to eq(1)
    
    visit '/'
    expect(page).to have_content 'Sign in'
    fill_in 'Email', with: 'testuser@gov.uk'
    fill_in 'Password', with: 'password123'
    click_button 'Continue'
    expect(page).to have_content 'Signed in successfully.'
  end
    
    
  it "publishes an update to the register" do
    visit 'country/new'
    expect(page).to have_content 'Country'
    fill_in 'country', with: 'zz'
    fill_in 'name', with: 'name'
    fill_in 'official-name', with: 'official name'
    fill_in 'start-date', with: '2014-05'
    fill_in 'end-date', with: '2014-05'
    click_button 'Continue'
    
    expect(page).to have_content 'Check the details of your new country'
    click_button 'Submit'
      
    visit '/country#updates'
    expect(page).to have_content 'zz'
    review_items = page.all(:xpath, '//a[contains(text(), "Review")]')
    review_items[0].click
    expect(page).to have_content 'zz'  
    choose('approve_yes')  
    click_button 'Continue'
      
    expect(page).to have_content 'Approve update'
    check 'confirm_approve'  
    click_button 'Approve'
    expect(page).to have_content 'The record has been published.'  
    
  end
end