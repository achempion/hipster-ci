require 'rails_helper'

describe 'Github' do

  describe 'commit notification' do
    let!(:project) { create(:project, path: 'my/project') }

    describe 'push event' do
      context 'with valid request' do
        before do
          post '/triggers/github', {repository: {full_name: 'my/project'}, head_commit: {id: 'sha-of-commit'}}, {'X-GitHub-Event' => 'push'}
        end

        it do
          expect(response.status).to eq(200)

          expect(project.builds.first.sha).to eq('sha-of-commit')
        end
      end

      context 'with invalid event type' do
        before do
          post '/triggers/github', {repository: {full_name: 'my/project'}, head_commit: {id: 'sha-of-commit'}}
        end

        it do
          expect(response.status).to eq(422)
        end
      end

      context 'with unknown project' do
        before do
          post '/triggers/github', {repository: {full_name: 'project/missed-name'}, head_commit: {id: 'sha-of-commit'}}, {'X-GitHub-Event' => 'push'}
        end

        it do
          expect(response.status).to eq(404)
        end
      end
    end
  end

end