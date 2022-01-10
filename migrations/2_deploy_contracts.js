const Staking = artifacts.require("Staking");
const FIFA = artifacts.require("FIFA");
const Bookie = artifacts.require("Bookie");

module.exports = function(deployer) {
  deployer.deploy(Staking).then (async  _ => {
    await deployer.deploy(FIFA, "BETOKEN", "BET", Staking.address);
    await deployer.deploy(Bookie);
  });
};
