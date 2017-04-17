var Event = artifacts.require("./Event.sol");

contract('Event', function(accounts) {
  it("should put 10000 Tickets in the first account", function() {
    return Event.deployed().then(function(instance) {
      return instance.balanceOf.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
    });
  });

  it("should create a new event and do some purchases", function() {
    var event;

    //    Get initial balances of first and second account.
    var account_one = web3.eth.accounts[0];
    var account_two = web3.eth.accounts[1];

    var account_one_starting_balance;
    var account_two_starting_balance;
    var account_one_ending_balance;
    var account_two_ending_balance;

    var noOfTickets = 10;

    return Event.new("testToken", 5, 5, 10000, [10, 10, 5, 1], ["0xE53cf86D89B8d3EfcDae60851561437a0d198a25", "0x02120039B395ec74Ce40232Bf74b59e7C444697e", "0xE7C9FA5fD36d32F5D3810514d289646368C957AD", "0x5D451D90B7Cd6a8aA4228C970067a7DdA3115626"], true).then(function(instance) {
      event = instance;
      return event.balanceOf.call(account_one);
    }).then(function(balance) {
      account_one_starting_balance = balance.toNumber();
      return event.balanceOf.call(account_two);
    }).then(function(balance) {
      account_two_starting_balance = balance.toNumber();
      return event.purchase(noOfTickets, 5, 0, {from: account_two, value: 50});
    }).then(function(tx_id) {
      return event.balanceOf.call(account_one);
    }).then(function(balance) {
      account_one_ending_balance = balance.toNumber();
      return event.balanceOf.call(account_two);
    }).then(function(balance) {
      account_two_ending_balance = balance.toNumber();
      assert.equal(account_one_ending_balance, account_one_starting_balance - noOfTickets, "Amount wasn't correctly taken from the sender");
      assert.equal(account_two_ending_balance, account_two_starting_balance + noOfTickets, "Amount wasn't correctly sent to the receiver");
    });
  })

  it("should send coin correctly", function() {
    var event;

    //    Get initial balances of first and second account.
    var account_one = web3.eth.accounts[0];
    var account_two = web3.eth.accounts[1];

    var account_one_starting_balance;
    var account_two_starting_balance;
    var account_one_ending_balance;
    var account_two_ending_balance;

    var noOfTickets = 10;

    return Event.deployed().then(function(instance) {
      event = instance;
      return event.balanceOf.call(account_one);
    }).then(function(balance) {
      account_one_starting_balance = balance.toNumber();
      return event.balanceOf.call(account_two);
    }).then(function(balance) {
      account_two_starting_balance = balance.toNumber();
      return event.purchase(noOfTickets, 5, 0, {from: account_two, value: 50});
    }).then(function(tx_id) {
      return event.balanceOf.call(account_one);
    }).then(function(balance) {
      account_one_ending_balance = balance.toNumber();
      return event.balanceOf.call(account_two);
    }).then(function(balance) {
      account_two_ending_balance = balance.toNumber();
      assert.equal(account_one_ending_balance, account_one_starting_balance - noOfTickets, "Amount wasn't correctly taken from the sender");
      assert.equal(account_two_ending_balance, account_two_starting_balance + noOfTickets, "Amount wasn't correctly sent to the receiver");
    });

  });
});
