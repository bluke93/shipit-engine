# frozen_string_literal: true

class AddPullRequestStackNumberToCommits < ActiveRecord::Migration[8.1]
  def change
    add_column(:commits, :pull_request_stack_number, :integer)
  end
end
