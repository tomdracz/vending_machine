module VendingMachineExceptions
  class InvalidCoinError < StandardError
    def message
      'Invalid coin provided'
    end
  end

  class CoinReturnError < StandardError
    def message
      'Cannot return the requested amount of coins'
    end
  end

  class ProductRemoveError < StandardError
    def message
      'Cannot remove more products then available'
    end
  end

  class NotEnoughChange < StandardError
    def message
      'Cannot dispense required amount of change'
    end
  end
end
