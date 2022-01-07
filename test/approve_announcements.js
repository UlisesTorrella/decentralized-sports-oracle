const FIFA = artifacts.require("FIFA");

contract('FIFA', (accounts) => {
  it('should solidify a team announcement', async () => {
    const FIFAInstance = await FIFA.deployed();

    const teamId = accounts[1];
    const teamName = "Spain";
    const announcementId = 0;

    // stake account 1
    // stake account 2
    // stake account 3
    // stake account 4
    // stake account 5

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
    assert.equal(state, 1, "The announcement should not have enough votes.");
  });
});
