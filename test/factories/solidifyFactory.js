async function solidifyTeamFactory (FIFAInstance, announcementId, teamAddress, teamName, ...addresses) {
  await FIFAInstance.announceTeam(teamAddress, teamName);

  const promises = addresses.map( async (address) => {
    await FIFAInstance.approveTeamAnnouncement(announcementId, teamAddress, teamName, {from: address});
  });
  await Promise.all(promises);
  return promises;
}

async function solidifyGameFactory (FIFAInstance, announcementId, gameAddress, ...addresses) {
  const promises = addresses.map( async (address) => {
    await FIFAInstance.approveGameAnnouncement(announcementId, gameAddress, {from: address, gas:3000000});
  });
  await Promise.all(promises);
  return promises;
}

module.exports = {solidifyTeamFactory, solidifyGameFactory};
