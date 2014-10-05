require 'rails_helper'

describe 'projects' do

  context 'with builds' do
    before do
      create_project('repo/project1', 'secret')
      create_project('repo/project2', 'secret')

      visit projects_path
    end

    context 'displayed' do
      it do
        expect(page).to have_content('repo/project1')
        expect(page).to have_content('repo/project2')
      end
    end

    context 'remove one' do
      let(:project2) { Project.find_by!(path: 'repo/project2') }

      before do
        find("a[href='/projects/#{project2.id}'][data-method='delete']").click
      end

      it { expect(page).to_not have_content('repo/project2') }
    end
  end

  context 'without builds' do
    before { create(:project) }

    context 'not raise errors' do
      it { expect { visit projects_path }.to_not raise_error }
    end
  end

  it 'validation specs'
end