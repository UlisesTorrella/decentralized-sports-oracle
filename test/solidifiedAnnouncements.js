const FIFA = artifacts.require("FIFA");
const Stake = artifacts.require("Staking");

const stakerFactory = require('./factories/stakerFactory');
const solidifyTeamFactory = require('./factories/solidifyFactory');

contract('FIFA', (accounts) => {
  it('should solidify a game announcement', async () => {
    const FIFAInstance = await FIFA.deployed();
    const StakeInstance = await Stake.deployed();

    await stakerFactory(StakeInstance, accounts[0], accounts[1], accounts[2], accounts[3], accounts[3]);

    const team1Name = "Spain";
    const team1 = await web3.eth.accounts.create(team1Name);
    var announcementTeam1Id = 0;
    const team2Name = "Argentina";
    const team2 = await web3.eth.accounts.create(team2Name);
    var announcementTeam2Id = 1;

    await solidifyTeamFactory(FIFAInstance, announcementTeam1Id, team1.address, team1Name, accounts[0], accounts[1], accounts[2], accounts[3], accounts[4]);
    await solidifyTeamFactory(FIFAInstance, announcementTeam2Id, team2.address, team2Name, accounts[0], accounts[1], accounts[2], accounts[3], accounts[4]);

    const game = await web3.eth.accounts.create("Game SPA-ARG");
    const date = 159;
    const gameAnnouncementId = 2;
    await FIFAInstance.announceGame(game.address, date, team1.address, team2.address);
    await FIFAInstance.approveGameAnnouncement(gameAnnouncementId, game.address, {from: accounts[0]});
    await FIFAInstance.approveGameAnnouncement(gameAnnouncementId, game.address, {from: accounts[1]});
    const announcement = await FIFAInstance.approveGameAnnouncement(gameAnnouncementId, game.address, {from: accounts[2]});

    const eventType = announcement.logs[0].event;
    assert.equal(eventType, "AnnouncementSolidified", "Game Announcement correctly soliodified");
  });
});
