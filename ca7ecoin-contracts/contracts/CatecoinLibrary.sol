pragma solidity ^0.4.11;

library CatecoinLibrary{
    function calculateCurrentTimePeriod(uint startTimestamp) public view returns (uint256) {
      return ((now - startTimestamp) / 10800) % 8; // To TEST return currentTimePeriod
    }

    function calculateCurrentDayOfTheWeek(uint startTimestamp) public view returns (uint256) { // Day 0 is equal to Wednesday --> to change if not launched on 17.01.18
      return ((now - startTimestamp) / 86400) % 7; // To TEST return currentDayPeriod
    }
}
