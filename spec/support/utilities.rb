def create_project path, token, build_options={sha: 'sha', message: 'message'}
  allow_any_instance_of(ProjectService).to \
    receive(:last_commit).and_return(
      double(
        sha: build_options[:sha],
        commit: double(message: build_options[:message])
      )
    )

  visit root_path

  within '#new_project' do
    fill_in 'achempion/hipster-ci', with: path
    fill_in 'access token', with: token

    click_button 'Create'
  end

  Project.find_by!(path: path)
end