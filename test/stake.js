const Stake = artifacts.require("Stake");

contract('Stake', (accounts) => {
  it('should set an account as an staker', async () => {
    const StakeInstance = await Stake.deployed();

    const accountOne = accounts[0];
    // await StakeInstance.stake({ from: accountOne });
    // 
    // const isStaking = await StakeInstance.isStaking.call(accountOne);
    // console.log(isStaking);
  });
});
