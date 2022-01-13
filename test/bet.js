const FIFA = artifacts.require("FIFA");
const Stake = artifacts.require("Staking");
const Bookie = artifacts.require("Bookie");

const stakerFactory = require('./factories/stakerFactory');
const {solidifyTeamFactory, solidifyGameFactory} = require('./factories/solidifyFactory');

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

    await stakerFactory(StakeInstance, accounts[0], accounts[1], accounts[2], accounts[3], accounts[3]);
    await solidifyTeamFactory(FIFAInstance, 0, spain.address, "Spain", accounts[0], accounts[1], accounts[2], accounts[3], accounts[4]);
    await solidifyTeamFactory(FIFAInstance, 1, arg.address, "Argentina", accounts[0], accounts[1], accounts[2], accounts[3], accounts[4]);
    await solidifyGameFactory(FIFAInstance, 2, argspain.address, accounts[0], accounts[1], accounts[2], accounts[3], accounts[4]);

    // fetch games

    // chose one

    // bet on team A
    const response = await BookieInstance.placeBet(FIFAInstance.address, argspain.address, arg.address, 100, {from: accounts[0]});

    const betAmount = (response.logs[0].args.amount).toNumber();
    assert.equal(100, betAmount, "Amounts does not match");
    const betWho = response.logs[0].args.who;
    assert.equal(accounts[0], betWho, "Better does not match");
    const betWinner = response.logs[0].args.win;
    assert.equal(arg.address, betWinner, "Team does not match");
    const betGame = response.logs[0].args.game;
    assert.equal(argspain.address, betGame, "Game does not match");

    const events = await BookieInstance.getPastEvents("Bet",{ fromBlock:0, toBlock:'latest'});
  });
});
