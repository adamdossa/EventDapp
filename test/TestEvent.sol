pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Event.sol";

contract TestEvent {

  function testInitialBalanceUsingDeployedContract() {
    Event eventInstance = Event(DeployedAddresses.Event());
    uint expected = 10000;
    Assert.equal(eventInstance.balanceOf(tx.origin), expected, "Owner should have 10000 Tickets initially");
  }

  function testInitialBalanceWithNewEvent() {
    Event eventInstance = new Event("testToken", 10, 5, 10000, [10, 10, 5, 1], [address(0xE53cf86D89B8d3EfcDae60851561437a0d198a25), 0x02120039B395ec74Ce40232Bf74b59e7C444697e, 0xE7C9FA5fD36d32F5D3810514d289646368C957AD, 0x5D451D90B7Cd6a8aA4228C970067a7DdA3115626], true);
    uint expected = 10000;
    Assert.equal(eventInstance.balanceOf(this), expected, "Owner should have 10000 Tickets initially");
  }

}
