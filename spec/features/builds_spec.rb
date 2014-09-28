require 'rails_helper'

describe 'builds' do

  before do
    @project = create_project('repo/project1', 'secret', 'last-sha')

    visit projects_path
  end

  describe 'builds page' do
    before { visit builds_path }

    context 'sha of last commit are displayed' do
      it { expect(page).to have_content('last-sh') }
    end

    context 'have a link to project' do
      it { expect(page).to have_selector("a[href='#{project_path(@project)}']") }
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

    context 'don\'t have a link to project' do
      it { expect(page).to_not have_selector("a[href='#{project_path(@project)}']") }
    end
  end
end