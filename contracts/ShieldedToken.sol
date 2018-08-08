pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol";
import "./DevDao.sol";
import "./Bancor.sol";

//tokens and ether expressed in elementary particles unless specified otherwise
contract MirageToken is ERC827Token{

  DevDao public devDao;
  Bancor public bancor;
  uint   public createdAt;
  uint   public totalSupply;
  uint   public E18 = 1000000000000000000;

  constructor() public {
    createdAt = now; // or 1518567207 Feb 14 2018: Date of first meeting
    devDao = new DevDao(address(this));
    bancor = new Bancor();
  }

  function updateDevTokens() public {
    uint newSupply = momentarySupply();
    balances[devDao] += newSupply - totalSupply;
    totalSupply = newSupply;
  }

  function momentarySupply() view public returns(uint){
    // 67167592423 67167592054
    (uint256 estimate, uint256 precision) = bancor.power(67167592423, 67167592054, uint32(now - createdAt), 1);
    // "2**precision / estimate" is reciprocal which we want because we wanted the 
    // result of the negative exponent all along.
    uint unmined = 21000000 * 2**precision / estimate;
    // precision of power function seems to max 128. is this ok because 256 uint 
    // limit is 256? the number above should round up so the following will round down
    return (21000000 - unmined - 1) * E18; // -1 so it  is always rounded down
  }
}









