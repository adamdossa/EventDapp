pragma solidity ^0.4.2;

contract SimpleContractTest {
    /* Constructor */
    event ReturnValue(address _from, uint256 _value);
    bytes8 public someInput;
    function SimpleContractTest(bytes8 _someInput)
    payable
    {
      someInput = _someInput;
    }
    function getByte(uint i) constant returns (bytes1 perc)
    {
      return someInput[i];
    }
    function myBalanceConstant() constant returns (uint256 amount)
    {
      return msg.sender.balance;
    }
    function contractBalanceConstant() constant returns (uint256 amount)
    {
      return this.balance;
    }
    function myBalancePublic() public returns (uint256 amount)
    {
      ReturnValue(msg.sender, msg.sender.balance);
      return msg.sender.balance;
    }
    function contractBalancePublic() public returns (uint256 amount)
    {
      ReturnValue(msg.sender, msg.sender.balance);
      return this.balance;
    }
}
