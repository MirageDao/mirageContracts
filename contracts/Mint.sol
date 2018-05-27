pragma solidity 0.4.24;

import "./Pow.sol";

library Mint{



  function excessReserves() view returns(uint){
    //make sure this number rounds down
    //make sure all scoping is correct
    return address(this).balance ;// - (this.totalSupply / 1000000000 * reservePPB());
  }
  // function reserves() view returns(uint){ return mirageToken.balance; }

  // fractional reserve ratio in parts per billion
  // should depend on time and not change from minting/burning
  function reservePPB() view returns (uint){
    // seconds in 18 months (moore) = 47304000
    // 1.00000001465303538
    // todo: this has to actually compute the shit in parts per billion
    return  5;// Pow.exp10(10000000147, (now - this.createdAt));
  } //view
}





