pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol";
import "./GnosisWallet.sol";
import "./Bancor.sol";
import "./shieldLogic.sol";

//tokens and ether expressed in elementary particles unless specified otherwise
contract MirageToken is ERC827Token{

  address public collective;
  address public shieldLogic;
  Bancor  public bancor;
  uint    public createdAt;
  uint    public totalSupply;
  uint    constant E18 = 1000000000000000000;

  constructor(address _collective, address _bancor) public {
    createdAt = now; // or 1518567207 Feb 14 2018: Date of first meeting
    collective = _collective;
    bancor = Bancor(_bancor);
  }


  // function () payable{
  //   shieldLogic.call.value(msg.value)(data);
  // //   //use a forward to upgrade and extend contract interface
  // //   revert("not yet available");
  // }

  modifier onlyCollective(){ if (msg.sender == collective) _; }

  function changeCollective(address _collective) onlyCollective { collective = _collective; }
  function changeShieldLogic(address _shieldLogic) onlyCollective { shieldLogic = _shieldLogic; }

  function releaseTokens() public onlyCollective {
    uint newSupply = momentarySupply() - totalSupply;
    totalSupply          += newSupply;
    balances[collective] += newSupply;
  }

  function shield(uint value, bytes data) payable{
    approve(shieldLogic, value);
    shieldLogic.call.value(msg.value)(data);
  }

  function unshield(bytes data) payable{
    shieldLogic.call.value(msg.value)(data);
  }

  // function shieldedTransfer(bytes data) payable{
  //   shieldLogic.call.value(msg.value)(data);
  //  // to keep with past ERC20 tokens, shieldedTx doesnt have to be on 
  //  // the token. It wont be for the others so might as well not be here.
  // }

  function momentarySupply() view public returns(uint){
    (uint256 estimate, uint256 precision) = bancor.power(67167592423, 67167592054, uint32(now - createdAt), 1);
    // "2**precision / estimate" is reciprocal which we want because we wanted the 
    // result of the negative exponent all along.
    uint unmined = 21000000 * 2**precision / estimate;
    // precision of power function seems to max 128. is this ok because 256 uint 
    // limit is 256? the number above should round up so the following will round down
    return (21000000 - unmined - 1) * E18; // -1 so it  is always rounded down
  }
}







