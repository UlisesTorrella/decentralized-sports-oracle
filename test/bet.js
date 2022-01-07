const FIFA = artifacts.require("FIFA");
const Stake = artifacts.require("Stake");
const Bookie = artifacts.require("Bookie");

contract('Bookie', (accounts) => {
  it('should place a bet', async () => {
    const FIFAInstance = await FIFA.deployed();
    const StakeInstance = await Stake.deployed();
    const BookieInstance = await Bookie.deployed();
    
    const accountOne = accounts[0];
    const balance = await web3.eth.getBalance(accountOne);
    console.log(balance);
    await StakeInstance.stake({ from: accountOne, value: 1e18 + 500000 });
    isOneStaking = await StakeInstance.isStaking.call(accountOne);

    assert.equal(isOneStaking, true, "Account One should be staking after stake.");


    const spain = await web3.eth.accounts.create("España");
    await FIFAInstance.announceTeam(spain.address, "Spain");
    const arg = await web3.eth.accounts.create("Argentina");
    await FIFAInstance.announceTeam(arg.address, "Argentina");
    
    // const events = await FIFAInstance.getPastEvents("TeamAnnouncement",{ fromBlock:0, toBlock:'latest'});
    // console.log(events);

    const argspain = await web3.eth.accounts.create("Argentina-España");
    await FIFAInstance.announceGame(argspain.address, Date.now(), spain.address, arg.address);    
    // fetch games
    
    // chose one


    // bet on team A
    console.log(arg.address);
    await BookieInstance.placeBet(FIFAInstance.address, argspain.address, arg.address, 100);
    const events = await BookieInstance.getPastEvents("Bet",{ fromBlock:0, toBlock:'latest'});
    console.log(events);
    
  });
});
