# typed: true
# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GraphQL
      # This cop checks if the descriptions of boolean fields start with "Whether".
      #
      # @example
      #   # bad
      #   field :active, :boolean, null: false, description: "The user is active."
      #
      #   # good
      #   field :active, :boolean, null: false, description: "Whether the user is active."
      #
      class DescriptionWhether < Base
        extend AutoCorrector

        MSG = "In field descriptions with :boolean type, start the description with \"Whether\"".freeze

        BOOLEAN_PATTERN = /\AWhether .*\.\z/
        ARTICLE_PATTERN = /\A(The|A|An) .*\.\z/

        def on_send(node)
          return unless node.method?(:field)

          type = node.arguments[1].children[0]
          return unless type == :boolean

          description = node.arguments.find { |arg| arg.hash_type? }.pairs.find { |pair| pair.key.value == :description }&.value&.value
          return if description.nil?

          add_offense(node, message: MSG) unless description.match?(BOOLEAN_PATTERN)
        end

        def autocorrect(node)
          lambda do |corrector|
            description_node = node.arguments.find { |arg| arg.hash_type? }.pairs.find { |pair| pair.key.value == :description }&.value

            new_description = autocorrect_description(description_node.value)
            corrector.replace(description_node, new_description)
          end
        end

        private

        def autocorrect_description(description)
          case description
          when BOOLEAN_PATTERN
            description
          when ARTICLE_PATTERN
            "\"Whether " + description[1..].downcase
          when / whether /
            "\"Whether " + description.split(" whether ").last
          when / if /
            "\"Whether to " + description.split(" if ").last
          when / to /
            "\"Whether to " + description.split(" to ").last
          else
            first_word = description.split.first
            if first_word.end_with?('s')
              infinitive_verb = first_word.chomp('s') # This is a simple way to get the infinitive form of a regular verb. It won't work for irregular verbs.
              "\"Whether to #{infinitive_verb} " + description.split(' ', 2).last.downcase
            else
              "\"Whether #{description}\""
            end
          end
        end
      end
    end
  end
end
