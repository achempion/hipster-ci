namespace :scheduler do
  desc "Build daemon"
  task perform: :environment do

    loop do
      build = Build.scheduled.first

      if build
        project = build.project

        build.in_progress!

        `
          rm -rf builds/#{build.id} &&
          mkdir -p builds/#{build.id} &&
          cd builds/#{build.id} &&
          git clone https://#{project.access_token}@github.com/#{project.path} . &&
          git checkout #{build.sha}
        `

        bundle_status =
          Bundler.with_clean_env do
            system "cd builds/#{build.id} && bundle >> bundle_result"
          end

        if bundle_status
          spec_status =
              Bundler.with_clean_env do
                system "cd builds/#{build.id} && bundle exec rspec >> spec_result"
              end

          build.result = `cd builds/#{build.id} && cat spec_result`

          if spec_status && build.result.include?('0 failures')
            build.success!
          else
            build.fail!
          end
        else
          build.result = `cd builds/#{build.id} && cat bundle_result`
          build.fail!
        end
      end

      sleep 5
    end
  end

end
