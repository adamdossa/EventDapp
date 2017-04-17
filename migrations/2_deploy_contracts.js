// var ConvertLib = artifacts.require("./ConvertLib.sol");
// var MetaCoin = artifacts.require("./MetaCoin.sol");
var Event = artifacts.require("./Event.sol");

module.exports = function(deployer) {
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(MetaCoin);
  deployer.deploy(Event, "testToken", 5, 5, 10000, [10, 10, 5, 1], ["0xE53cf86D89B8d3EfcDae60851561437a0d198a25", "0x02120039B395ec74Ce40232Bf74b59e7C444697e", "0xE7C9FA5fD36d32F5D3810514d289646368C957AD", "0x5D451D90B7Cd6a8aA4228C970067a7DdA3115626"], true);
};
