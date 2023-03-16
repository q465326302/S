pragma solidity ^0.8.7;
contract QuantitativeInvestment{
    uint256 public btcPrice;
    uint256 lasPrice;
    uint256 lasTimestment;
    uint256 public investment;

    constructor(uint256 _investment){
        increment = _investment;
    }
    function invest() public {
        (bool success, bytes memory result) = address(this).call.value(investment)("");
        require(success);
        lastTimestamp = block.timestamp;
    }

    function updatePrice(uint256 _price) public {
        lastPrice = btcPrice;
        btcPrice = _price;
        lastTimestamp = block.timestamp;
    }

    function calculateReturns() public view returns (int256) {
        require(btcPrice > 0 && lastPrice > 0, "Prices not set yet");
        uint256 timeDiff = block.timestamp - lastTimestamp;
        uint256 returns = (btcPrice - lastPrice) * 1 ether / lastPrice;
        int256 investmentReturn = int256(returns) * int256(investment) / int256(1 ether);
        int256 annualizedReturns = investmentReturn * int256(31536000) / int256(timeDiff);
        return annualizedReturns;
    }
}
}