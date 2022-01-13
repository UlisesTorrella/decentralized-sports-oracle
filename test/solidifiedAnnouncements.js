const FIFA = artifacts.require("FIFA");
const Stake = artifacts.require("Staking");

const stakerFactory = require('./factories/stakerFactory');
const {solidifyTeamFactory, solidifyGameFactory} = require('./factories/solidifyFactory');

contract('FIFA', (accounts) => {
  var announcementId = 0;
  it('should solidify a game announcement', async () => {
    const FIFAInstance = await FIFA.deployed();
    const StakeInstance = await Stake.deployed();

    await stakerFactory(StakeInstance, accounts[0], accounts[1], accounts[2], accounts[3], accounts[3]);

    const team1Name = "Spain";
    const team1 = await web3.eth.accounts.create(team1Name);
    await solidifyTeamFactory(FIFAInstance, announcementId, team1.address, team1Name, accounts[0], accounts[1], accounts[2], accounts[3], accounts[4]);

    const team2Name = "Argentina";
    const team2 = await web3.eth.accounts.create(team2Name);
    announcementId++;
    await solidifyTeamFactory(FIFAInstance, announcementId, team2.address, team2Name, accounts[0], accounts[1], accounts[2], accounts[3], accounts[4]);

    const game = await web3.eth.accounts.create("Game SPA-ARG");
    const date = 159;
    await FIFAInstance.announceGame(game.address, date, team1.address, team2.address);
    announcementId++;
    await FIFAInstance.approveGameAnnouncement(announcementId, game.address, {from: accounts[0]});
    await FIFAInstance.approveGameAnnouncement(announcementId, game.address, {from: accounts[1]});
    const announcement = await FIFAInstance.approveGameAnnouncement(announcementId, game.address, {from: accounts[2]});

    const eventType = announcement.logs[0].event;
    assert.equal(eventType, "AnnouncementSolidified", "Game Announcement correctly soliodified");
  });
  it('should solidify a goal announcement', async () => {
    const FIFAInstance = await FIFA.deployed();

    const team1Name = "Germany";
    const team1 = await web3.eth.accounts.create(team1Name);
    announcementId++;
    await solidifyTeamFactory(FIFAInstance, announcementId, team1.address, team1Name, accounts[0], accounts[1], accounts[2], accounts[3], accounts[4]);

    const team2Name = "China";
    // const team2 = await web3.eth.accounts.create(team2Name);
    announcementId++;
    await solidifyTeamFactory(FIFAInstance, announcementId, accounts[8], team2Name, accounts[0], accounts[1], accounts[2], accounts[3], accounts[4]);

    const game = await web3.eth.accounts.create("Game BRA-GER");
    const date = 159;
    await FIFAInstance.announceGame(game.address, date, team1.address, accounts[8]);
    announcementId++;
    await solidifyGameFactory(FIFAInstance, announcementId, game.address, accounts[0], accounts[1], accounts[2], accounts[3], accounts[4]);

    const jersey = 10;
    const minute = 89;
    const goalAnn = await FIFAInstance.announceGoal(game.address, minute, team1.address, jersey);
    announcementId++;

    await FIFAInstance.approveGoalAnnouncement(announcementId, {from: accounts[0], gas:3000000});
    await FIFAInstance.approveGoalAnnouncement(announcementId, {from: accounts[1], gas:3000000});
    const approval2 = await FIFAInstance.approveGoalAnnouncement(announcementId, {from: accounts[2], gas:3000000});

    const eventType = approval2.logs[0].event;
    assert.equal("AnnouncementSolidified", eventType, "Event Type does not match");
    const approvalAnnouncementId = approval2.logs[0].args.announcementId;
    assert.equal(announcementId, approvalAnnouncementId, "announcementId does not match");
  });
  it('should solidify a game status announcement', async () => {

  });
});
