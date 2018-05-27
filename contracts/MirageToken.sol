pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol";
import "./Mint.sol";
import "./DevDao.sol";

contract MirageToken is ERC827Token{

  DevDao      public devDao;
  uint        public createdAt;
  uint        public totalSupply;

  constructor(){
    createdAt = now;
    devDao = new DevDao();
    // maybe deploy Mint and Pow library here
  }


  function skim() {
    devDao.transfer(Mint.excessReserves());
  }
  function buy() payable {
    skim();
    _buy();
  }
  function sell(uint amount){
    skim();
    _sell(amount);
  }


  function _buy() private {
    // require(totalSupply + msg.value >= totalSupply) // seems unnecessary
    //does this fail elegantly with sending eth and minting coins (4 cases)
    uint tokensBought = msg.value / buyPriceTimesOneBillion(msg.value) / 1000000000;
    totalSupply += tokensBought;
    balances[msg.sender] += tokensBought;
  }
  function _sell(uint tokensSold) private {
    // require(totalSupply + tokensSold >= totalSupply);//because tokesnsold is unvetted
    require(balances[msg.sender] >= tokensSold);// removes need for above line
    uint etherRewarded = tokensSold * sellPriceTimesOneBillion(tokensSold) / 1000000000;

    totalSupply -= tokensSold;
    balances[msg.sender] -= tokensSold;
    msg.sender.transfer(etherRewarded);
  }
  function buyPriceTimesOneBillion(uint etherAmount) view returns(uint){ return 101; }
  function sellPriceTimesOneBillion(uint tokenAmount) view returns(uint){ return 99; }
}








