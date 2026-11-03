# frozen_string_literal: true

module Shipit
  class FetchPullRequestStackJob < BackgroundJob
    queue_as :default

    def perform(commit)
      commit.fetch_pull_request_stack!
    end
  end
end
