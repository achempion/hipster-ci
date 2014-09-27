def create_project path, token, sha = 'sha'
  allow_any_instance_of(ProjectService).to receive(:last_commit).and_return(double(sha: sha))

  visit root_path

  within '#new_project' do
    fill_in 'achempion/hipster-ci', with: path
    fill_in 'access token', with: token

    click_button 'Create'
  end
end