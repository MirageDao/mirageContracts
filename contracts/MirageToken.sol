pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol";
// import "./Pow.sol";
import "./DevDao.sol";


//all tokens expressed in elementary particles unless otherwise specified
contract MirageToken is ERC827Token{

  DevDao      public devDao;
  uint        public createdAt;
  uint        public totalSupply;
  uint        public lastPrice_x_E6;
  uint constant       public E6  = 1000000;
  uint        public E9  = 1000000000;
  uint        public E18 = 1000000000000000000;
  uint        public E26 = 100000000000000000000000000;

  constructor(){
    createdAt = now; // 1518567207 Feb 14 2018: Date of first meeting
    lastPrice_x_E6 = 1000000;
    devDao = new DevDao();
    // maybe deploy Mint and Pow library here
  }


  function skim() {
    uint reserveRatio_x_E6 = fracExp(1000000, 68245410, timeSinceGenesis(), 6);
    if(overfunded()){
      uint excessReserves = this.balance - totalSupply * lastPrice_x_E6 / 1000000 * reserveRatio_x_E6 / 1000000;
      devDao.transfer(excessReserves);
    }else{ //underfunded
      uint tokensToMint = totalSupply - this.balance * 1000000 * 1000000 / lastPrice_x_E6 / reserveRatio_x_E6;
      totalSupply += tokensToMint;
      balances[devDao] += tokensToMint;
    }
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
    //does this fail elegantly with sending wei and minting coins (4 cases)
    // uint tokensBought = msg.value / buyPriceTimesOneBillion(msg.value) / 1000000000;
    uint tokensIssued = tokensToIssue(msg.value);
    totalSupply += tokensIssued;
    balances[msg.sender] += tokensIssued;
  }

  function _sell(uint tokensSold) private {
    require(balances[msg.sender] >= tokensSold);
    uint weiRewarded = tokensSold * sellPrice_x_E6(tokensSold) / 1000000;

    totalSupply -= tokensSold;
    balances[msg.sender] -= tokensSold;
    msg.sender.transfer(weiRewarded);
  }

  // = H3*((1+F4/E4)^(B4)-1)
  // = 
  // do this from directions - and logically check later
  //low balance=E1 weiPaym=E26  1 + E26 => significant raise
  //high balcnce=E26 weiPaym=E1: 1 + 1/E26 => should still raise price slightly
  function tokensToIssue(uint weiPayment) view returns(uint){
    uint term1_x_E26 = E26 + E26 * weiPayment / this.balance;
    //could be 1 - E52
    uint term2_x_E6  = fracExp(E18, term1_x_E26, now - createdAt , 6); //check all this shit
    // totalSupply * finish this line!!!
    return 5; //stub stubly
  }

  // function buyPriceTimesOneBillion(uint weiAmount) view returns(uint){
  //   return 101;
  // }

  function sellPrice_x_E6(uint tokenAmount) view returns(uint){
    return 99;
  }

  function timeSinceGenesis() view returns(uint){
    return now - createdAt;
  }

  function overfunded() view returns(bool){
    //more than target at current time
    return now % 2 == 0 ? false : true; // stub
  }

  // ex: 1000000, 68245410, 47304000, 6
  function fracExp(uint k, uint q, uint n, uint p) pure returns (uint) {
    uint s = 0;
    uint N = 1;
    uint B = 1;
    for (uint i = 0; i < p; ++i){
      s += k * N / B / (q**i);
      N  = N * (n-i);
      B  = B * (i+1);
    }
    return k * k / s;
  }
}








