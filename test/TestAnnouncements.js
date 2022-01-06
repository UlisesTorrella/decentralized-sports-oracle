const FIFA = artifacts.require("FIFA");

contract('FIFA', (accounts) => {
  it('should announce a team', async () => {
    const FIFAInstance = await FIFA.deployed();

    const teamId = accounts[1];
    const teamName = "Spain";

    await FIFAInstance.announceTeam(teamId, teamName);
    const teamAnnounced = (await FIFAInstance.getAnnouncedTeamName.call(teamId));

    assert.equal(teamAnnounced, teamName, "Team `Spain` was not announced");
  });
  it('should announce a game', async () => {
    const FIFAInstance = await FIFA.deployed();

    const gameId = accounts[1];
    const gameDate = 45;
    const teamA = accounts[2];
    const teamB = accounts[3];

    await FIFAInstance.announceGame(gameId, gameDate, teamA, teamB);

    const announcedGameDate = (await FIFAInstance.getAnnouncedGameDate.call(gameId)).toNumber();
    assert.equal(announcedGameDate, gameDate, "Game date was not announced properly");
  });
});
