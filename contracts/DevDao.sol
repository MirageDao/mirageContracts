pragma solidity 0.4.24;

// derive from owned
contract DevDao{
  address mirageToken;

  constructor(_mirageToken){
    mirageToken = _mirageToken;
  }

  function() public payable {}


}
