# frozen_string_literal: true

require 'test_helper'

module Shipit
  class FetchPullRequestStackJobTest < ActiveSupport::TestCase
    setup do
      @commit = shipit_commits(:first)
      @job = FetchPullRequestStackJob.new
    end

    test "#perform call #fetch_pull_request_stack! on the provided commit" do
      @commit.expects(:fetch_pull_request_stack!).once
      @job.perform(@commit)
    end
  end
end
