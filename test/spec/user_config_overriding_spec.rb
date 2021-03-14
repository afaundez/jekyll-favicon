# frozen_string_literal: true

require 'spec_helper'

describe 'user favicon config overrides favicon defaults' do
  context fixture: :config
  subject { @context.config['favicon'] }
  let(:user_config_path) { @context.source '_config.yml' }
  let(:user_config) { YAML.load_file(user_config_path)['favicon'] }

  it 'overrides default config attributes' do
    %w[background path sizes source].each do |attribute|
      _(subject[attribute]).must_equal user_config[attribute]
    end
  end
end
