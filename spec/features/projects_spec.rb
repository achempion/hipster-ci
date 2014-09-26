require 'rails_helper'

describe 'projects' do

  before do
    visit root_path

    within '#new_project' do
      fill_in 'achempion/hipster-ci', with: 'project/path'

      click_button 'Create'
    end
  end

  context 'displayed' do
    it { expect(page).to have_content('project/path') }
  end

  context 'removeed' do
    before { find('.project-item-actions a.badge', visible: false).click }

    it { expect(page).to_not have_content('project/path') }
  end
end