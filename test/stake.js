const FIFA = artifacts.require("FIFA");
const Stake = artifacts.require("Staking");

contract('Stake', (accounts) => {
  it('should set an account as an staker', async () => {
    const StakeInstance = await Stake.deployed();
    const FIFAInstance = await FIFA.deployed();

    const accountOne = accounts[5];
    const accountTwo = accounts[6];

    let isOneStaking = await FIFAInstance.isStaking.call(accountOne);
    assert.equal(isOneStaking, false, "Account One should not be staking.");
    let isTwoStaking = await FIFAInstance.isStaking.call(accountTwo);
    assert.equal(isTwoStaking, false, "Account Two should not be staking.");

    await StakeInstance.stake({ from: accountOne, value: 1e18 });
    isOneStaking = await FIFAInstance.isStaking.call(accountOne);
    assert.equal(isOneStaking, true, "Account One should be staking after stake.");

    // check that the other account is not staking
    isTwoStaking = await FIFAInstance.isStaking.call(accountTwo);
    assert.equal(isTwoStaking, false, "Account Two should not be staking.");
  });
  it('fail staking for insuficcient funds', async () => {
    const StakeInstance = await Stake.deployed();
    const FIFAInstance = await FIFA.deployed();

    const accountOne = accounts[4];

    let isOneStaking = await FIFAInstance.isStaking.call(accountOne);
    assert.equal(isOneStaking, false, "Account One should not be staking.");

    try {
        await StakeInstance.stake({ from: accountOne});
    } catch (err) {
        assert.equal(err.reason, "Failed to send money, check your funds", "Account One should not be staking after stake with not enough funds.");
        isOneStaking = await FIFAInstance.isStaking.call(accountOne);
        assert.equal(isOneStaking, false, "Account One should not be staking after stake with not enough funds.");
    }
  });
});
