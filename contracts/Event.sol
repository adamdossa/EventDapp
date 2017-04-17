pragma solidity ^0.4.8;

contract Event {

  event DistributeRevenue(address _from, address _to, uint256 _amount, bool _success);
  event EventCreated(address _owner, uint256 _initalSupply);
  event BalanceRequested(address _caller);

  address public owner;
  uint256 public createdTime;
  string public description;
  uint256 public initialCost;
  uint256 public allowedTransfers;
  uint256 public totalSupply;
  bool public capPrice;
  uint256 public currentId = 0;
  address[4] public distributionAddresses;
  uint8[4] public distributionAmounts;

  mapping (address => Ticket[]) public balances;
  address[] public balanceAddresses;
  uint256[] public balanceIndexes;

  struct Ticket {
    uint256 id; //fixed
    uint256 supply; //variable
    bool forSale; //variable
    uint256 cost; //fixed
    uint256 sales; //fixed
    uint256 previousId; //fixed
  }

  //"testToken", 10, 5, 100, [10, 10, 5, 1], ["0xE53cf86D89B8d3EfcDae60851561437a0d198a25", "0x02120039B395ec74Ce40232Bf74b59e7C444697e", "0xE7C9FA5fD36d32F5D3810514d289646368C957AD", "0x5D451D90B7Cd6a8aA4228C970067a7DdA3115626"], "true"
  //Constructor
  function Event(
      string _description,
      uint256 _initialCost,
      uint256 _allowedTransfers,
      uint256 _initialSupply,
      uint8[4] _distributionAmounts,
      address[4] _distributionAddresses,
      bool _capPrice)
  {
    //Event level initialization
    description = _description;
    initialCost = _initialCost;
    allowedTransfers = _allowedTransfers;
    capPrice = _capPrice;
    owner = msg.sender;
    createdTime = now;
    totalSupply = _initialSupply;
    distributionAddresses = _distributionAddresses;
    distributionAmounts = _distributionAmounts;
    //Ticket level initialization
    Ticket memory newTicket;
    newTicket.supply = _initialSupply;
    newTicket.cost = _initialCost;
    newTicket.sales = _allowedTransfers;
    newTicket.forSale = true;
    newTicket.id = 0;
    balances[msg.sender].push(newTicket);
    balanceAddresses.push(msg.sender);
    balanceIndexes.push(0);
    EventCreated(msg.sender, _initialSupply);
  }

  function balanceOf(address _owner)
    constant
    returns (uint256 balance)
  {
    //returns the total number of tickets
    uint256 totalBalance = 0;
    for (uint256 i = 0; i < balances[_owner].length; i++)
    {
      totalBalance = totalBalance + balances[_owner][i].supply;
    }
    BalanceRequested(_owner);
    return totalBalance;
  }

  function distributeRevenue(address _from)
    payable
    returns (bool success)
  {
    uint256 totalSent = 0;
    for (uint256 i = 0; i < distributionAddresses.length; i++)
    {
      uint256 distributionAmount = (msg.value * distributionAmounts[i]) / 100;
      bool sendResult = distributionAddresses[i].send(distributionAmount);
      DistributeRevenue(msg.sender, distributionAddresses[i], distributionAmount, sendResult);
      totalSent += distributionAmount;
    }
    bool ownerSend = _from.send(msg.value - totalSent);
    DistributeRevenue(msg.sender, _from, msg.value - totalSent, ownerSend);
  }

  //"0x02120039B395ec74Ce40232Bf74b59e7C444697e", 10, 10, 0
  function purchase(uint256 _numberOfTickets, uint256 _price, uint256 _ticketId)
    payable
    returns (bool success)
  {

    //Pay to play
    if (msg.value != _price * _numberOfTickets) throw;

    address ticketAddress = balanceAddresses[_ticketId];
    uint256 ticketIndex = balanceIndexes[_ticketId];

    //Iterate over _from ticket types and check that we have a match
    if (balances[ticketAddress][ticketIndex].id == _ticketId &&
        balances[ticketAddress][ticketIndex].supply > _numberOfTickets &&
        balances[ticketAddress][ticketIndex].sales > 0 &&
        balances[ticketAddress][ticketIndex].forSale == true)
    {
      balances[ticketAddress][ticketIndex].supply -= _numberOfTickets;

      Ticket memory newTicket;
      newTicket.supply = _numberOfTickets;
      newTicket.sales = balances[ticketAddress][ticketIndex].sales - 1;
      newTicket.previousId = _ticketId;
      newTicket.id = currentId + 1;
      newTicket.forSale = false;
      currentId += 1;
      balances[msg.sender].push(newTicket);

      balanceIndexes.push(balances[msg.sender].length - 1);
      balanceAddresses.push(msg.sender);
      distributeRevenue(ticketAddress);
      return true;
    }

    throw;
  }

  function putOnSale(uint256 _ticketId)
  {
    //Must own tickets
    address ticketAddress = balanceAddresses[_ticketId];
    uint256 ticketIndex = balanceIndexes[_ticketId];
    if (ticketAddress != msg.sender) throw;

    balances[ticketAddress][ticketIndex].forSale = true;
  }

  function takeOffSale(uint256 _ticketId)
  {
    //Must own tickets
    address ticketAddress = balanceAddresses[_ticketId];
    uint256 ticketIndex = balanceIndexes[_ticketId];
    if (ticketAddress != msg.sender) throw;

    balances[ticketAddress][ticketIndex].forSale = false;
  }

}
