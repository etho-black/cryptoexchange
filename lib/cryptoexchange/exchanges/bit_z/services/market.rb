module Cryptoexchange::Exchanges
  module BitZ
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
          "#{Cryptoexchange::Exchanges::BitZ::Market::API_URL}/tickerall"
        end

        def adapt_all(output)
          output["data"].map do |key, value|
            base = key.split("_").first
            target = key.split("_").last
            market_pair = Cryptoexchange::Models::MarketPair.new(
                            base: base,
                            target: target,
                            market: BitZ::Market::NAME
                          )
            adapt(value,market_pair)
          end
        end

        def adapt(output, market_pair)
          ticker = Cryptoexchange::Models::Ticker.new
          ticker.base = market_pair.base
          ticker.target = market_pair.target
          ticker.market = BitZ::Market::NAME
          ticker.ask = NumericHelper.to_d(output['sell'])
          ticker.bid = NumericHelper.to_d(output['buy'])
          ticker.last = NumericHelper.to_d(output['last'])
          ticker.high = NumericHelper.to_d(output['high'])
          ticker.low = NumericHelper.to_d(output['low'])
          ticker.volume = NumericHelper.to_d(output['vol'])
          ticker.timestamp = NumericHelper.to_d(output['date'])
          ticker.payload = output
          ticker
        end
      end
    end
  end
end
