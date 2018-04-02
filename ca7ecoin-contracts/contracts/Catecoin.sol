pragma solidity ^0.4.11;

import './token/StandardToken.sol';

contract Catecoin is StandardToken {
  /*
   *  Token meta data
   */
  string constant public name = "Catecoin";
  string constant public symbol = "CA7E";
  uint8  constant public decimals = 18;

  uint256 public totalSupplyCC;
  uint256 public circulatingSupplyCC;

  function Catecoin() public {
    // constructor
  }
}
