const { ethers } = require("hardhat");

async function main() {
    // Deploying MyNFT contract


        const MyNFT = await ethers.getContractFactory("MNFT");
        console.log("Deploying NFT and marketplace");

        const mynft = await MyNFT.deploy();

        console.log("MyNFT deployed at: ",mynft.target);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
});


// 0xb2585913df561DD4602721457fbeA61513865982