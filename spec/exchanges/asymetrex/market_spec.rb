require 'spec_helper'

RSpec.describe Cryptoexchange::Exchanges::Asymetrex::Market do
  it { expect(described_class::NAME).to eq 'asymetrex' }
  it { expect(described_class::API_URL).to eq 'https://asymetrex.com/api' }
end
