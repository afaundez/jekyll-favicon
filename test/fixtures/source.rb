# frozen_string_literal: true

require 'fixtures/file'

module Fixtures
  # Write files in destination
  module Source
    FILE_TYPES = %i[favicon browserconfig webmanifest config index].freeze

    def self.build(destination, file_specs = {})
      FILE_TYPES.each do |file_type|
        next unless (spec = file_specs[file_type])

        target = ::File.join destination, spec[:name]
        File.create file_type, target, spec[:options]
      end
    end
  end
end
