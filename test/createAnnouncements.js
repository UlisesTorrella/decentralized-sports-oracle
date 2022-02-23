const FIFA = artifacts.require("FIFA");
const teamAnnouncementContract = artifacts.require("TeamAnnouncement");

contract('FIFA', (accounts) => {
  it('should announce a team', async () => {
    const FIFAInstance = await FIFA.deployed();

    const teamId = accounts[1];
    const teamName = "Spain";

    const announcement = TeamAnnouncement(FIFAInstance.address, teamName)
    await FIFAInstance.announce(announcement.address);

    // Check that team was correctly stored.
    const teamAnnounced = (await FIFAInstance.getAnnouncedTeamName.call(teamId));
    assert.equal(teamAnnounced, teamName, "Team `Spain` was not announced");

    // Check that event was made properly.
    const eventType = announcement.logs[0].event;
    const eventTeamId = announcement.logs[0].args.teamId;
    const eventTeamName = announcement.logs[0].args.name;

    assert.equal(eventType, "TeamAnnouncement", "AnnouncementType is not correct");
    assert.equal(eventTeamId, teamId, "Announced team id is not correct");
    assert.equal(eventTeamName, teamName, "Announced team name is not correct");
  });
  // it('should announce a game', async () => {
  //   const FIFAInstance = await FIFA.deployed();

  //   const gameId = accounts[1];
  //   const gameDate = 45;
  //   const teamA = accounts[2];
  //   const teamB = accounts[3];

  //   const announcement = await FIFAInstance.announceGame(gameId, gameDate, teamA, teamB);

  //   // Check that game was correctly stored.
  //   const announcedGameDate = (await FIFAInstance.getAnnouncedGameDate.call(gameId)).toNumber();
  //   assert.equal(announcedGameDate, gameDate, "Game date was not announced properly");

  //   // Check that event was made properly.
  //   const eventType = announcement.logs[0].event;
  //   const eventGameId = announcement.logs[0].args.gameId;
  //   const eventGameDate = (announcement.logs[0].args.date).toNumber();
  //   const eventTeamA = announcement.logs[0].args.teamA;
  //   const eventTeamB = announcement.logs[0].args.teamB;

  //   assert.equal(eventType, "GameAnnouncement", "AnnouncementType is not correct");
  //   assert.equal(eventGameId, gameId, "Announced game id is not correct");
  //   assert.equal(eventGameDate, gameDate, "Announced game date is not correct");
  //   assert.equal(eventTeamA, teamA, "Announced team A is not correct");
  //   assert.equal(eventTeamB, teamB, "Announced team B is not correct");
  // });
  // it('should announce a goal', async () => {
  //   const FIFAInstance = await FIFA.deployed();

  //   // Announce game
  //   const gameId = accounts[4];
  //   const gameDate = 10;
  //   const teamA = accounts[5];
  //   const teamB = accounts[6];
  //   await FIFAInstance.announceGame(gameId, gameDate, teamA, teamB);

  //   const minute = 48;
  //   const jersey = 10;
  //   const announcement = await FIFAInstance.announceGoal(gameId, minute, teamB, jersey);

  //   const eventType = announcement.logs[0].event;
  //   const eventJersey = (announcement.logs[0].args.jersey).toNumber();
  //   const eventMinute = (announcement.logs[0].args.minute).toNumber();
  //   const eventTeam = announcement.logs[0].args.awarder;

  //   assert.equal(eventType, "GoalAnnouncement", "AnnouncementType is not correct");
  //   assert.equal(eventJersey, jersey, "Announced jersey is not correct");
  //   assert.equal(eventMinute, minute, "Announced minute is not correct");
  //   assert.equal(eventTeam, teamB, "Announced team is not correct");
  // });
  // it('should create a game status announcement', async () => {
  //   const FIFAInstance = await FIFA.deployed();

  //   // Announce game
  //   const gameId = accounts[5];
  //   const gameDate = 80;
  //   const teamA = accounts[6];
  //   const teamB = accounts[7];
  //   await FIFAInstance.announceGame(gameId, gameDate, teamA, teamB);

  //   const statusStarted = 1;
  //   const announcement = await FIFAInstance.announceGameStatus(gameId, statusStarted);

  //   const eventType = announcement.logs[0].event;
  //   const eventState = (announcement.logs[0].args.status).toNumber();

  //   assert.equal(eventType, "StatusAnnouncement", "AnnouncementType is not correct");
  //   assert.equal(eventState, statusStarted, "Announced state is not correct");
  // });
});
