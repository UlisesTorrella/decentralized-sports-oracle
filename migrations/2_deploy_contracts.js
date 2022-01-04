const Stake = artifacts.require("Stake");

module.exports = function(deployer) {
  deployer.deploy(Stake);
};
