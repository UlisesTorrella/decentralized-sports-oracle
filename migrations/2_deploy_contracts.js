const Stake = artifacts.require("Stake");
const FIFA = artifacts.require("FIFA");
const Bookie = artifacts.require("Bookie");

module.exports = function(deployer) {
  deployer.deploy(Stake).then ( _ => {
    deployer.deploy(FIFA, "BETOKEN", "BET", Stake.address);
    deployer.deploy(Bookie);
  });
};
