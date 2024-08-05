# all posible distribution channels
module Channel
  BETA = :beta
  RELEASE = :release
end

# Results to be shown to the enduser at the end of the build lanes
ENV_FA_RESULT = "ENV_FA_RESULT"

# where to distribute sdk zips
SDK_BUCKET = "bryj-sdks"

# The plugin name to use
PLUGIN_NAME = "Build_V3_Plugin_Monitoring_ios"

# The plugin project name
PLUGIN_PROJECT = "Build-V3-Plugin-Monitoring-ios"

# The plugin repo
PLUGIN_REPO = "git@github.com:bryjai/bryj-build-private-pods.git"

# The private pod repo name
POD_REPO_NAME = "bryj-build-private-pods"

DEPENDENCIES = "spec.dependency 'FASDKBuild-ios', '>= 3.9.5'\n  spec.dependency 'GROW', '>= 1.2.4'"

def append_build_message(msg)
  empty = ENV[ENV_FA_RESULT].empty?
  ENV[ENV_FA_RESULT] +=  if empty then  msg else "\n" + msg end
end
