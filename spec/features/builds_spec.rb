require 'rails_helper'

describe 'builds' do

  before do
    create_project('repo/project1', 'secret', 'last-sha')

    visit projects_path
  end

  describe 'builds page' do
    before { visit builds_path }

    context 'sha of last commit are displayed' do
      it { expect(page).to have_content('last-sh') }
    end
  end

  describe 'project page' do
    before do
      visit projects_path

      click_link('repo/project1')
    end

    context 'sha of last commit are displayed' do
      it { expect(page).to have_content('last-sh') }
    end
  end
end