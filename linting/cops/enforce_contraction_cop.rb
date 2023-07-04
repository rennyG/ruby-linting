

# typed: true
# frozen_string_literal: true

require "rubocop-graphql"

module Cops
  module GraphQL
    # This cop enforces proper contraction use in descriptions.
    #
    # @example
    #   # good
    #
    #   class UserMutation < GraphApi::Mutation
    #     field: :user_id, :id, null: false, description: "The ID of the user can't be a duplicate"
    #   end
    #
    #   # bad
    #
    #   class UserMutation < GraphApi::Mutation
    #    field: :user_id, :id, null: false, description: "The ID of the user cannot be a duplicate"

    class DescriptionoContractions <  ::RuboCop::Cop::Base
      extend RuboCop::Cop::AutoCorrector
      include ::RuboCop::GraphQL::NodePattern

      MSG =
