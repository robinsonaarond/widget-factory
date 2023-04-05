class StatusController < ActionController::Base
  def ping
    render json: {status: "success", data: {response: "pong"}}
  end

  def check
    render json: {
      status: "success",
      data: {
        schema_version: version,
        rails_env: Rails.env.to_s,
        git_tag: git_tag,
        git_hash: git_hash,
        git_branch: git_branch
      }
    }
  end

  def clear_cache
    render json: {status: "fail"} and return if Rails.env.production?
    Rails.cache.clear
    render json: {status: "success"}
  end

  protected

  # TODO: Once we're off Jenkins we can rely on the env variables only
  def git_tag
    ENV["GIT_TAG"] || `git describe --tags`.chomp
  end

  def git_hash
    ENV["GIT_HASH"] || `git log --format="%h" -1`.chomp
  end

  def git_branch
    ENV["GIT_BRANCH"] || `git name-rev --name-only --refs="remotes/*" #{git_hash}`.strip.split("/").last
  end

  def version
    if defined?(ActiveRecord) && defined?(ActiveRecord::Migrator)
      ActiveRecord::Migrator.current_version
    else
      "Not Available"
    end
  rescue ActiveRecord::StatementInvalid
    "Not Available"
  end
end
