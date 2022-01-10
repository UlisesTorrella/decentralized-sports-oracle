const FIFA = artifacts.require("FIFA");

contract('FIFA', (accounts) => {
  it('should put 10000 FIFA in the first account', async () => {
    const FIFAInstance = await FIFA.deployed();
    const balance = await FIFAInstance.balanceOf.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
  it('should send coin correctly', async () => {
    const FIFAInstance = await FIFA.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await FIFAInstance.balanceOf.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await FIFAInstance.balanceOf.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await FIFAInstance.transfer(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await FIFAInstance.balanceOf.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await FIFAInstance.balanceOf.call(accountTwo)).toNumber();


    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });
});
