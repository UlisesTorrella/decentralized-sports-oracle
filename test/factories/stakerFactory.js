async function stakerFactory (StakeInstance, ...addresses) {
  const promises = addresses.map( async (address) => {
    await StakeInstance.stake({ from: address, value: 1e18 });
  });
  await Promise.all(promises);
  return promises;
}

module.exports = stakerFactory;