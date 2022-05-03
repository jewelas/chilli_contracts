async function main() {
    const RKVesting = await ethers.getContractFactory("RKVesting")
    const RaceKingdomAddr = "0xbAcE844B57E841364E8b5b089177e2408cc556a3";
  
    // Start deployment, returning a promise that resolves to a contract object
    const myContract = await RKVesting.deploy(RaceKingdomAddr)
    await myContract.deployed()
    console.log("Contract deployed to address:", myContract.address)
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })
  