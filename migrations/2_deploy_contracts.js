const Stake = artifacts.require("Stake");
const FIFA = artifacts.require("FIFA");
const Bookie = artifacts.require("Bookie");

module.exports = async function(deployer) {
  await deployer.deploy(Stake);
  await deployer.deploy(FIFA, "BETOKEN", "BET", Stake.address);
  await deployer.deploy(Bookie);
};
