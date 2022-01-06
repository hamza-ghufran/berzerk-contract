const { networkConfig } = require('../helper')

module.exports = async ({
  getNamedAccounts,
  deployments,
  getChainId
}) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = await getChainId()

  log('<--------------------------------------->')

  async function deployContract(args) {
    const berzerkContract = await deploy('Berzerk', {
      from: deployer,
      log: true,
      args: args
    })

    return berzerkContract
  }

  async function initContract({ address }) {
    const accounts = await hre.ethers.getSigners()
    const signer = accounts[0]
    const berzerkNFTContract = await ethers.getContractFactory('Berzerk')

    const berzerk = new ethers.Contract(address, berzerkNFTContract.interface, signer)

    return { berzerk }
  }

  const SUPPLY = 1
  /**
    * @arg name
    * @arg symbol
    * @arg maxNftSupply = SUPPLY
    */
  const args = ['Berzerk', '∫', SUPPLY]

  const { address } = await deployContract(args)
  log(`<<< Berzerk Contract succesfully deployed to ${address} >>>`)
  log('<--------------------------------------->')

  const { berzerk } = await initContract({ address })
  const networkName = networkConfig[chainId]['name']

  log(`<<< Verify with: \n npx hardhat verify --network ${networkName} ${address} >>>`)
  log('<--------------------------------------->')

  for (let index = 1; index <= SUPPLY; index++) {
    const txnRes = await berzerk.buyMeABerzerk(index)
    const receipt = await txnRes.wait(1)

    log(`<<< You have made an NFT! >>>`)
    log(`<<< You can view the ${index} tokenURI here:: ${await berzerk.tokenURI(index)} >>>`)
  }
}

module.exports.tags = ['all', 'bizerk']