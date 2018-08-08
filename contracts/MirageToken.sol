pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol";
import "./DevDao.sol";
import "./Bancor.sol";


//tokens and ether expressed in elementary particles unless specified otherwise
contract MirageToken is ERC827Token{

  DevDao      public devDao;
  Bancor      public bancor;
  uint        public createdAt;
  uint        public totalSupply;
  uint        public lastSpotPrice_x_E6;
  uint        public E6  = 1000000;

  constructor() public {
    createdAt = now; // or 1518567207 Feb 14 2018: Date of first meeting
    lastSpotPrice_x_E6 = 1000000;
    devDao = new DevDao();
    bancor = new Bancor();
  }


  function updateEthReserves() public {
    // 1.0000000146530353805^-47304000 is 60874760069/60874759177 ^ 47304000/1
    // if(overfunded()){
    uint excessReserves = address(this).balance - totalSupply * lastSpotPrice_x_E6 / 1000000 * reserveRatio_x_E6() / 1000000;
    address(devDao).transfer(excessReserves);
  }
  // function updateDevTokens() public {
  //       // }else{ //underfunded
  //     // // note the difference found in price here might be due to the fact that
  //     // // normally the money coming in is used to buy tokens *first* and then the
  //     // // team funds are used to buy them second; Whereas here (underfunded case) the
  //     // // team buys tokens, then the investors tokens are created.
  //   // uint tokensToMint = totalSupply - address(this).balance * 1000000 * 1000000 / price_x_E6 / reserveRatio_x_E6;
  //   // totalSupply += tokensToMint;
  //   // balances[devDao] += tokensToMint;
  //   // }
  // }
  function buy() public payable {
    updateEthReserves();
    _buy();
  }
  function sell(uint amount) public {
    updateEthReserves();
    _sell(amount);
  }

  function _buy() private {
    // require(totalSupply + msg.value >= totalSupply) // seems unnecessary
    //does this fail elegantly with sending wei and minting coins (4 cases)
    // uint tokensBought = msg.value / buyPriceTimesOneBillion(msg.value) / 1000000000;
    uint tokensIssued = bancor.calculatePurchaseReturn(totalSupply, address(this).balance, uint32(reserveRatio_x_E6()), msg.value);
    totalSupply += tokensIssued;
    balances[msg.sender] += tokensIssued;
    _updateSpotPrice();
  }
  function _sell(uint tokensSold) private {
    require(balances[msg.sender] >= tokensSold);
    uint weiRewarded = bancor.calculateSaleReturn(totalSupply, address(this).balance, uint32(reserveRatio_x_E6()), tokensSold);

    totalSupply -= tokensSold;
    balances[msg.sender] -= tokensSold;
    msg.sender.transfer(weiRewarded);
    _updateSpotPrice();
  }
  function _updateSpotPrice() private {
    lastSpotPrice_x_E6 = address(this).balance / totalSupply * E6 / reserveRatio_x_E6();
  }

  function reserveRatio_x_E6() view public returns(uint){
    // find a way to cache this better. currently 3 calls in each buy() call
    // updates are only 5000 gas, seems easy enough? "lastreserveRatio_x_E6" so 
    // people dont try to read is as current.
    (uint256 estimate, uint256 precision) = bancor.power(60874760069, 60874759177, uint32(now - createdAt), 1);
    return estimate * E6 / 2**precision; //shouldnt overflow...
  }
  // function priceToBuy_x_E6(uint ETH) view public returns(uint){
  //   return address(this).balance / totalSupply * E6 / reserveRatio_x_E6();
  // }
  // function priceToSell_x_E6(uint tokens) view public returns(uint){
  //   return address(this).balance / totalSupply * E6 / reserveRatio_x_E6();
  // }
}








