pragma solidity ^0.4.24;

contract shieldLogic {
  // address mirage;
  // address collective;
  // contructor(address _mirageToken, address _collective){
  //   mirage = _mirage;
  //   collective = _collective;
  // }
  // modifier onlyCollective(){ if (msg.sender == collective) _; }

  function () payable{
  //   //really no point of using this with a forward function to 
  //   //shield and unsheild because we can already upgrade this whole 
  //   //contract anyway. if anything the other token could use a forward 
  //   //because it could extend its interface
    revert("not yet available");
  }

  function shield(bytes data) payable{
    revert("not yet available");
  }

  function unshield(bytes data) payable{
    revert("not yet available");
  }

  // function shield(bytes data) payable{
  //   mirage.transferFrom(from, address(this), value);
  // }
  // function unshield(bytes data) payable{
  //   if(proofIsCorrect){
  //     mirage.transfer(to, value)
  //   }
  // }

  // function upgrade() onlyCollective{   }

  // this version doesnt need upgrade path for transfering deposits,
  // because it doesnt take any
}
