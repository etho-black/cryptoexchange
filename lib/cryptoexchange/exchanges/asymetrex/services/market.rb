module Cryptoexchange::Exchanges
  module Asymetrex
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            false
          end
        end

        def fetch
          output = super(ticker_url)
          adapt_all(output)
        end

        def ticker_url
          "#{Cryptoexchange::Exchanges::Asymetrex::Market::API_URL}/tickers"
        end


        def adapt_all(output)
          output.map do |ticker|
            symbol = ticker[0].upcase
            adapt(ticker)
          end
        end

        def adapt(output)
          return unless output[1]['ticker']['name']
          target, base = output[1]['ticker']['name'].split("/")

          ticker           = Cryptoexchange::Models::Ticker.new
          ticker.base      = base
          ticker.target    = target
          ticker.market    = Asymetrex::Market::NAME
          ticker.ask       = NumericHelper.to_d(output[1]['ticker']['sell'])
          ticker.bid       = NumericHelper.to_d(output[1]['ticker']['buy'])
          ticker.last      = NumericHelper.to_d(output[1]['ticker']['last'])
          ticker.change    = NumericHelper.to_d(output[1]['ticker']['change'])
          ticker.high      = NumericHelper.to_d(output[1]['ticker']['high'])
          ticker.low       = NumericHelper.to_d(output[1]['ticker']['low'])
          ticker.volume    = NumericHelper.to_d(output[1]['ticker']['vol'])
          ticker.timestamp = nil
          ticker.payload   = output
          ticker
        end
      end
    end
  end
end
