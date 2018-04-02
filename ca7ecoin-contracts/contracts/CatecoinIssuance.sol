pragma solidity ^0.4.11;

import './Catecoin.sol';
/*import './CatecoinCompetition.sol';
import './CatecoinDonation.sol';
import './CatecoinLibrary.sol';
import './math/Math.sol';
import './math/SafeMath.sol';*/
/**
 * @title Catecoin Issuance contract
 *
 * @dev Implements all the functions to claim catecoin
 * @dev based on the Standard ERC20 Token OpenZeppelin implementatio
 */
/* is Catecoin, CatecoinLibrary, Math, SafeMath */
contract CatecoinIssuance is Catecoin {
    /*using Math for *;
    using SafeMath for *;*/
    /*using Math for *;
    using SafeMath for *;
    using CatecoinLibrary for *;*/
  /**
   * @section Rename all useful functions from the libraries
   *
   */

   /*using substractSafely for SafeMath.sub;*/

  /**
   * @section Define all state variables for the issuance part
   *
   */
   address public catecoinFoundationAddress;

   bytes20 public cateAddressInBytes = bytes20(0xCa7e000000000000000000000000000000000000);
   uint256 public CA7E = 10**18;
   uint256 public milliCA7E = 10**15;
   uint256 public microCA7E = 10**12;
   uint256 public nanoCA7E = 10**9;

   uint public startTimestamp = 1516147200; //equivalent to Wednesday, January 17, 2018 12:00:00 AM (GMT)
   bool public issuanceIsFinished;

   struct Supply {
     uint256 all;
     uint256 mining;
     uint256 competition;
     uint256 donation;
   }

   Supply totalSupply;
   Supply circulatingSupply;

   uint256 currentHalvingValue;
   uint256[78] halvingInterval;

   modifier catecoinIsLive() {
     require(now >= startTimestamp);
     _;
   }

   modifier isCA7E() {
     _;
   }

   modifier maxCirculatingSupply() {
     require(circulatingSupply.all <= totalSupply.all);
     _;
   }

   modifier issuanceIsFinishedModifier() {
     require(!issuanceIsFinished);
     _;
   }

  /**
   * &subsection Mining
   */
   mapping (uint8 => uint256) countClaimedAddressesByDifficulty; //RENAME TO: minedAddresses
   mapping (address => bool) addressHasClaimed;

   modifier addressHasClaimedModifier() {
     require(!addressHasClaimed[msg.sender]);
     _;
   }

  /**
   * &subsection Competition
   */
   struct Compet_senderState {
     bool hasParticipated;
     bool hasClaimed;
   }

   struct Periods {
     uint256 timePeriod;
     uint256 dayPeriod;
   }

   //e.g strengthTable[even = true | odd = false][timePeriodOfTheDay][dayPeriodOfTheDay] = strenght
     mapping (bool =>
       mapping (uint256 =>
         mapping (uint256 => uint256))) strengthTable; // strength
   mapping (bool =>
     mapping (uint256 =>
       mapping (uint256 => uint256))) rewardTable;
   mapping (address => Periods) whenHasParticipated;
   mapping (address => Compet_senderState) public competSenderState;

   modifier hasNotParticipatedInCompetition() {
     require(competSenderState[msg.sender].hasParticipated == false);
    /* if(addressHasParticipatedInCompetition[msg.sender].hasParticipated != 0) throw;
*/     _;

   }

   modifier hasNotClaimedInCompetition() {
     var t = competSenderState[msg.sender];
     require(t.hasClaimed == false);
     _;
   }

   /**
    * &subsection Donation
    */
    /*modifier auctionHasEnded() {*/
      /*require(currentAuctionContract.auctionEnd < now + 77);*/
      /*SimpleAuction currentAuctionContract = SimpleAuction(currentAuction);*/
      /*_;*/
    /*}*/

  function CatecoinIssuance() public {
    // constructor
    catecoinFoundationAddress = msg.sender;

    totalSupply.all = totalSupplyCC; //See for the variable totalSupplyCC if it works
    totalSupply.mining = 3*CA7E;
    totalSupply.competition = 3*CA7E;
    totalSupply.donation = 1*CA7E;
    require(totalSupply.all == totalSupply.mining + totalSupply.competition + totalSupply.donation);
    //Initialize the range h || Warning: Be Careful with OUT OF GAS error
    for(uint i = 0; i < 77; i++){
      /*halvingInterval[i] = (2/3 * ((1 - (7/9)**i) / (1 - (7/9)))) * CA7E; //same formula as in the whitepaper -> Will certainly cause a out of gas error*/
    }
    // The geometric serie converges to 3
    halvingInterval[77] = 3;
  }

  /**
   * &subsection Mining
   */

  //Main function to claim catecoins
  function claimMinedCatecoin()
      public
      addressHasClaimedModifier //If the msg.sender has already claimed then throw
      catecoinIsLive //Catecoin must be live. The contract will be sent to the network before the launch
      maxCirculatingSupply //If the totalSupply is reached then just throw, because there are not more coins to claim
      issuanceIsFinishedModifier //Double check: if the totalSupply is reached then issuance is finished
      returns(bool) {
      uint8 senderAddressDifficulty = calculateDifficulty(bytes20(msg.sender));
      uint256 coinsToReceive = calculateMinedCatecoin(senderAddressDifficulty);

      bool transfer_OK = testAndSafelyTransferCatecoin(circulatingSupply.mining, totalSupply.mining, coinsToReceive, 0);
      require(transfer_OK);
      addressHasClaimed[msg.sender] = true;
      return transfer_OK;
  }

  function testAndSafelyTransferCatecoin(uint256 _circulatingSupply,
                                   uint256 _totalSupply,
                                   uint256 _coinsToReceive,
                                   uint8   _supplyType)
                                   public returns (bool)
  {

    bool transferToSender_passed;
    bool transferToFoundation_passed;
    uint256 adjustedCoinsToReceive;

    if (_circulatingSupply + _coinsToReceive <= _totalSupply) {
      transferToSender_passed      = transfer(msg.sender, _coinsToReceive * 6/7); //TO VERIFY: is this line valid?
      transferToFoundation_passed  = transfer(catecoinFoundationAddress, _coinsToReceive * 1/7);
    }
    else {
      adjustedCoinsToReceive      = sub(_totalSupply, _circulatingSupply); // Change all math function before upload to the git
      transferToSender_passed     = transfer(msg.sender, adjustedCoinsToReceive * 6/7);
      transferToFoundation_passed = transfer(catecoinFoundationAddress, adjustedCoinsToReceive * 1/7);
    }

    //Before preventing the sender to call the function again, check if the sender and the foundation received the coins
    bool allTransfers_passed = transferToSender_passed && transferToFoundation_passed;
    require(allTransfers_passed);

    if (_circulatingSupply + _coinsToReceive <= _totalSupply){
      if (_supplyType == 0) circulatingSupply.mining += _coinsToReceive;
      if (_supplyType == 1) circulatingSupply.competition += _coinsToReceive;
      if (_supplyType == 2) circulatingSupply.donation += _coinsToReceive;
    }
    else {
      if (_supplyType == 0) circulatingSupply.mining = totalSupply.mining;
      if (_supplyType == 1) circulatingSupply.competition = totalSupply.competition;
      if (_supplyType == 2) circulatingSupply.donation = totalSupply.donation;
      issuanceIsFinished = true;
    }

    return allTransfers_passed;
  }
/*
  function setNewCirculatingSupply(uint8 supplyType) public {

  }
*/
  /**
   * @dev Function to calculate the difficulty of an Ca7e Address
   * @param _claimerAddressInBytes bytes20 The address of the claimer translate in bytes20
   * @return A uint8 specifying the difficulty of the given address
   */
  function calculateDifficulty(bytes20 _claimerAddressInBytes) internal view returns (uint8) {
      uint8 countZeros = 0;
      bytes20 claimerAddressMasked = _claimerAddressInBytes ^ cateAddressInBytes;

      for(uint8 i = 0; i < claimerAddressMasked.length; i++) {
          // compare the claimer address to the "model" cate address
          if (claimerAddressMasked[i] == 0x00) {
              countZeros += 2;
          }
          else {
              //claimer address is at least equal to 0xCa7e********, where * stands for a hexadecimal excluding zero
              if (countZeros >= 4) {
                  //byte has a zero on the left side i.e 0x0*
                  if (uint8(claimerAddressMasked[i]) <= 15) {
                      countZeros += 1;
                      break;
                  }
                  //byte has only a zero on the right side but not on the left side i.e 0x*0
                  else {
                      break;
                  }
              }
              else {
                  break;
              }
          }
      }
      //claimer address has at least the prefix 0xca7e
      if (countZeros - 4 >= 0) {
          countZeros -= 4; //substract the counted bytes of the prefix
      }
      //claimer address is not of the right form
      else {
          countZeros = 0;
      }

      return countZeros;
  }

  function calculateMinedCatecoin(uint8 _senderAddressDifficulty) public returns(uint256) {
      uint256 h = calculateHalving();
      setNewHalving(h);
      uint256 d = _senderAddressDifficulty;
      /*uint256 minedCatecoin =min256(0.5*CA7E, 777.7777 * 10**(d - 1) * nanoCA7E) / 2**h; //TODO: test division*/
      uint256 minedCatecoin = div(min256(div(CA7E,2), div(7777777, 10^4) * 10**(d - 1) * nanoCA7E), 2**h); //TODO: test division

      return minedCatecoin;
  }

  function calculateHalving() public view returns (uint256) {
      for (uint256 i = currentHalvingValue; i < 77; i++) {
        if(halvingInterval[i] <= circulatingSupply.mining && circulatingSupply.mining < halvingInterval[i+1]) return i;
      }
  }

  function setNewHalving(uint256 _lastelyCalculatedHalvingValue) public {
    require(_lastelyCalculatedHalvingValue > currentHalvingValue);
    currentHalvingValue = _lastelyCalculatedHalvingValue;
  }

  /**
   * &subsection Competition
   */


   /**
    * &info The data will be available during 7 days only, after this, an address won't be able to claim anymore
    */
   function catecoinCompetition() public isCA7E hasNotParticipatedInCompetition returns(bool) {
      uint256 t = calculateCurrentTimePeriod(startTimestamp);
      uint256 d = calculateCurrentDayOfTheWeek(startTimestamp);
      uint256 s = calculateDifficulty(bytes20(msg.sender)); //strenght of sender's address
      bool evenAddress = (s % 2 == 0);

      // addresses have to claim the coins after the playing period
      strengthTable[evenAddress][t][d] += 16**s;
      rewardTable[evenAddress][t][d] += calculateMinedCatecoin(calculateDifficulty(bytes20(msg.sender)));
      whenHasParticipated[msg.sender].timePeriod = t;
      whenHasParticipated[msg.sender].dayPeriod = d;
      competSenderState[msg.sender].hasParticipated = true;
    }

   function claimMinedCatecoin_InCompetition() public hasNotClaimedInCompetition() returns(bool) {
      uint8 senderAddressDifficulty = calculateDifficulty(bytes20(msg.sender));
      uint256 coinsToReceive;
      uint  t =  whenHasParticipated[msg.sender].timePeriod;
      uint  d =  whenHasParticipated[msg.sender].dayPeriod;
      uint s =  calculateDifficulty(bytes20(msg.sender));
      uint256 strengthOfTheAddress = 16**s;
      bool evenAddress = (s % 2 == 0);

      // Checks if the competition in which the sender has participated has already finished
      require(calculateCurrentTimePeriod(now) != t && calculateCurrentDayOfTheWeek(now) != d);

      bool evenAddressesWon = (strengthTable[evenAddress][t][d] >= strengthTable[!evenAddress][t][d]);
      // Checks if the sender has won
      require(evenAddressesWon == evenAddress);

      coinsToReceive = calculateMinedCatecoin(senderAddressDifficulty) + (rewardTable[!evenAddress][t][d] * strengthOfTheAddress/strengthTable[evenAddress][t][d]);

      bool transfer_OK = testAndSafelyTransferCatecoin(circulatingSupply.competition, totalSupply.competition, coinsToReceive, 1);
      require(transfer_OK);
      competSenderState[msg.sender].hasClaimed = true;

      return transfer_OK;
    }
/*Catecoin Library util functions*/
    function calculateCurrentTimePeriod(uint _startTimestamp) public view returns (uint256) {
      return ((now - _startTimestamp) / 10800) % 8; // To TEST return currentTimePeriod
    }

    function calculateCurrentDayOfTheWeek(uint _startTimestamp) public view returns (uint256) { // Day 0 is equal to Wednesday --> to change if not launched on 17.01.18
      return ((now - _startTimestamp) / 86400) % 7; // To TEST return currentDayPeriod
    }
  /* ZEPPELIN Math.sol Libray*/
  function max64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a < b ? a : b;
  }

    /* ZEPPELIN SafeMath.sol Libray*/
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;

}
}
