const Stake = artifacts.require("Stake");
const FIFA = artifacts.require("FIFA");

module.exports = function(deployer) {
  deployer.deploy(Stake);
  deployer.deploy(FIFA, "BETOKEN", "BET");
};
