const Stake = artifacts.require("Stake");

contract('Stake', (accounts) => {
  it('should set an account as an staker', async () => {
    const StakeInstance = await Stake.deployed();

    const accountOne = accounts[5];
    let actualBalance = await web3.eth.getBalance(accountOne);
    console.log("balance", actualBalance);
    actualBalance = await web3.utils.fromWei(actualBalance, "ether")
    console.log("balance", actualBalance);
    await StakeInstance.stake({ from: accountOne, value: 1e18 });
    //
    // const isStaking = await StakeInstance.isStaking.call(accountOne);
    // console.log(isStaking);
  });
});
