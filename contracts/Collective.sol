pragma solidity 0.4.24;

// derive from owned
contract Collective{
  address mirageToken;

  constructor(){
    mirageToken = msg.sender;
  }

  function() public payable {}


  function forward(address destination, uint value, bytes data) private {
    if (!destination.call.value(value)(data)) { throw; }
    Forwarded(destination, value, data);
  }
}
