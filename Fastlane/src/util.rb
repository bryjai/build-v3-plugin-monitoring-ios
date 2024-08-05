require './src/env.rb'

platform :ios do
    # loads version number from version file
    def load_version_number
        File.read("../VERSION").strip
    end

    # reproductible buils number for snapshot #{no_commits}.#{git_hash}(-DIRTY)
    def get_build_number_from_git
        no_commits = number_of_commits
        repo_status = Actions.sh("git status --porcelain")
        repo_clean = repo_status.empty? ? "" : "-DIRTY"
        repo_clean = ""
        new_build_number = "#{no_commits}#{repo_clean}"
    end

    def get_version(channel)
        version_number = load_version_number
        version = if channel == :release then version_number else "#{version_number}-#{channel.to_s}" end
    end

    def get_full_version(channel, build_number)
        version = load_version_number
        full_version = if channel == :release then version else "#{version}-#{channel.to_s}.#{build_number}" end
    end

    # returns the relative path where to upload the sdk zip
    def create_zip_s3_path(channel ,zip_name, full_version)
        #for compatiblity reasons it puts releases in top level directory
        # and groups different channels in their own folders
        channel_folder =  if channel == :release then "" else "#{channel.to_s}/" end
        "build/plugins/#{PLUGIN_NAME}/#{channel_folder}#{full_version}/#{zip_name}"
    end
end
