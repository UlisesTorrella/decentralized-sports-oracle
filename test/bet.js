const FIFA = artifacts.require("FIFA");
const Stake = artifacts.require("Staking");
const Bookie = artifacts.require("Bookie");

const stakerFactory = require('./factories/stakerFactory');

contract('Bookie', (accounts) => {
  it('should place a bet', async () => {
    const FIFAInstance = await FIFA.deployed();
    const StakeInstance = await Stake.deployed();
    const BookieInstance = await Bookie.deployed();

    await stakerFactory(StakeInstance, accounts[0], accounts[1], accounts[2], accounts[3]);

    isOneStaking = await FIFAInstance.isStaking.call(accounts[0]);
    isTwoStaking = await FIFAInstance.isStaking.call(accounts[1]);
    isThreeStaking = await FIFAInstance.isStaking.call(accounts[2]);
    isFourStaking = await FIFAInstance.isStaking.call(accounts[3]);
    assert(isOneStaking && isTwoStaking && isThreeStaking && isFourStaking, "The stakers coulnd't be set");


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
