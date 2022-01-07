const FIFA = artifacts.require("FIFA");
const Stake = artifacts.require("Stake");

contract('FIFA', (accounts) => {
  it('should solidify a team announcement', async () => {
    const FIFAInstance = await FIFA.deployed();
    const StakeInstance = await Stake.deployed();

    const teamId = accounts[0];
    const teamName = "Spain";
    const announcementId = 0;

    // stake accounts
    const accountOne = accounts[1];
    await StakeInstance.stake({ from: accountOne, value: 1e18 });
    const accountTwo = accounts[2];
    await StakeInstance.stake({ from: accountTwo, value: 1e18 });
    const accountThree = accounts[3];
    await StakeInstance.stake({ from: accountThree, value: 1e18 });
    const accountFour = accounts[4];
    await StakeInstance.stake({ from: accountFour, value: 1e18 });
    const accountFive = accounts[5];
    await StakeInstance.stake({ from: accountFive, value: 1e18 });

    await FIFAInstance.announceTeam(teamId, teamName);

    await FIFAInstance.approveTeamAnnouncement(announcementId, teamId, teamName)
    var posVotes = (await FIFAInstance.getAnnouncementPosVotes.call(announcementId)).toNumber();
    assert.equal(posVotes, 1, "The announcement should have one vote.");
    var state = (await FIFAInstance.getAnnouncementState.call(announcementId)).toNumber();
    assert.equal(state, 0, "The announcement should not have enough votes.");

    await FIFAInstance.approveTeamAnnouncement(announcementId, teamId, teamName)
    posVotes = (await FIFAInstance.getAnnouncementPosVotes.call(announcementId)).toNumber();
    assert.equal(posVotes, 2, "The announcement should have two votes.");
    state = (await FIFAInstance.getAnnouncementState.call(announcementId)).toNumber();
    assert.equal(state, 0, "The announcement should not have enough votes.");

    await FIFAInstance.approveTeamAnnouncement(announcementId, teamId, teamName)
    posVotes = (await FIFAInstance.getAnnouncementPosVotes.call(announcementId)).toNumber();
    assert.equal(posVotes, 3, "The announcement should have three votes.");
    state = (await FIFAInstance.getAnnouncementState.call(announcementId)).toNumber();
    assert.equal(state, 1, "The announcement should be solidified.");
  });
  it('should disprove a team announcement', async () => {
    const FIFAInstance = await FIFA.deployed();
    const StakeInstance = await Stake.deployed();

    const teamId = accounts[6];
    const teamName = "Argentina";
    const announcementId = 1;

    await FIFAInstance.announceTeam(teamId, teamName);
    // Accounts already staked in previous test.

    await FIFAInstance.disproveAnnouncement(announcementId);
    var negVotes = (await FIFAInstance.getAnnouncementNegVotes.call(announcementId)).toNumber();
    assert.equal(negVotes, 1, "The announcement should have one vote.");
    var state = (await FIFAInstance.getAnnouncementState.call(announcementId)).toNumber();
    assert.equal(state, 0, "The announcement should not have enough votes.");

    await FIFAInstance.disproveAnnouncement(announcementId)
    negVotes = (await FIFAInstance.getAnnouncementNegVotes.call(announcementId)).toNumber();
    assert.equal(negVotes, 2, "The announcement should have two votes.");
    state = (await FIFAInstance.getAnnouncementState.call(announcementId)).toNumber();
    assert.equal(state, 0, "The announcement should not have enough votes.");

    await FIFAInstance.disproveAnnouncement(announcementId)
    negVotes = (await FIFAInstance.getAnnouncementNegVotes.call(announcementId)).toNumber();
    assert.equal(negVotes, 3, "The announcement should have three votes.");
    state = (await FIFAInstance.getAnnouncementState.call(announcementId)).toNumber();
    assert.equal(state, 2, "The announcement should be disproven.");
  });
  it('should not change announcement from solidified to disproven', async () => {
    const FIFAInstance = await FIFA.deployed();
    const StakeInstance = await Stake.deployed();

    const teamId = accounts[7];
    const teamName = "Brasil";
    const announcementId = 2;

    // Accounts already staked in previous test.

    await FIFAInstance.approveTeamAnnouncement(announcementId, teamId, teamName)
    await FIFAInstance.approveTeamAnnouncement(announcementId, teamId, teamName)
    await FIFAInstance.approveTeamAnnouncement(announcementId, teamId, teamName)
    var posVotes = (await FIFAInstance.getAnnouncementPosVotes.call(announcementId)).toNumber();
    assert.equal(posVotes, 3, "The announcement should have three positive votes.");
    var state = (await FIFAInstance.getAnnouncementState.call(announcementId)).toNumber();
    assert.equal(state, 1, "The announcement should be solidified.");

    await FIFAInstance.disproveAnnouncement(announcementId);
    await FIFAInstance.disproveAnnouncement(announcementId);
    await FIFAInstance.disproveAnnouncement(announcementId);
    var negVotes = (await FIFAInstance.getAnnouncementNegVotes.call(announcementId)).toNumber();
    assert.equal(negVotes, 3, "The announcement should have three negative votes.");
    var state = (await FIFAInstance.getAnnouncementState.call(announcementId)).toNumber();
    assert.equal(state, 1, "The announcement should be solidified and not disproven.");
  });
  it('should not change announcement from disproven to solidified', async () => {
    const FIFAInstance = await FIFA.deployed();
    const StakeInstance = await Stake.deployed();

    const teamId = accounts[8];
    const teamName = "Germany";
    const announcementId = 3;

    // Accounts already staked in previous test.

    await FIFAInstance.disproveAnnouncement(announcementId);
    await FIFAInstance.disproveAnnouncement(announcementId);
    await FIFAInstance.disproveAnnouncement(announcementId);
    var negVotes = (await FIFAInstance.getAnnouncementNegVotes.call(announcementId)).toNumber();
    assert.equal(negVotes, 3, "The announcement should have three negative votes.");
    var state = (await FIFAInstance.getAnnouncementState.call(announcementId)).toNumber();
    assert.equal(state, 2, "The announcement should be disproven.");

    await FIFAInstance.approveTeamAnnouncement(announcementId, teamId, teamName)
    await FIFAInstance.approveTeamAnnouncement(announcementId, teamId, teamName)
    await FIFAInstance.approveTeamAnnouncement(announcementId, teamId, teamName)
    var posVotes = (await FIFAInstance.getAnnouncementPosVotes.call(announcementId)).toNumber();
    assert.equal(posVotes, 3, "The announcement should have three positive votes.");
    var state = (await FIFAInstance.getAnnouncementState.call(announcementId)).toNumber();
    assert.equal(state, 2, "The announcement should be disproven and not solidified.");
  });
});
