pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol";
// import "./Collective.sol";
import "./GnosisWallet.sol";
import "./Bancor.sol";

//tokens and ether expressed in elementary particles unless specified otherwise
contract MirageToken is ERC827Token{

  address public collective;
  Bancor public bancor;
  uint   public createdAt;
  uint   public totalSupply;
  uint   public constant E18 = 1000000000000000000;

  constructor(address _collective) public {
    createdAt = now; // or 1518567207 Feb 14 2018: Date of first meeting
    collective = _collective;
    bancor = new Bancor();
  }

  modifier onlyCollective(){ if (msg.sender == collective) _; }

  function changeCollective(address _collective) onlyCollective { collective = _collective; }
  function changeShieldLogic(address _shieldLogic) onlyCollective { shieldLogic = _shieldLogic; }

  function releaseTokens() public onlyCollective {
    uint newSupply = momentarySupply() - totalSupply;
    totalSupply          += newSupply;
    balances[collective] += newSupply;
  }

  address shieldLogic;
  function shield(uint value, bytes data) payable{
    approve(value, shieldLogic)//check order
    shieldLogic.call.value(msg.value)(data)
  }

  function unshield(bytes data){
    shieldLogic.call.value(msg.value)(data)
  }

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

contract shieldLogic
  MirageToken mirage;
  Collective collective;
  modifier onlyCollective(){ if (msg.sender == collective) _; }

  // function () {

  // }

  function shield(bytes data) payable{
    revert("not yet available");
  }

  function unshield(bytes data) payable{
    revert;
  }

  // function shield(bytes data) payable{
  //   mirage.transferFrom(from, address(this), value);
  // }

  // function unshield(bytes data) payable{
  //   if(proofIsCorrect){
  //     mirage.transfer(to, value)
  //   }
  // }

  // function upgrade() onlyCollective{
  //   tran
  // }
  // this version doesnt need upgrade path for transfering deposits, because it doesnt take any







