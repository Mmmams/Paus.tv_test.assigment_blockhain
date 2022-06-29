async function main() {
  const Token = await ethers.getContractFactory("PausToken");
  const Marketplace = await ethers.getContractFactory("Marketplace");
  // Start deployment, returning a promise that resolves to a contract object
  const token = await Token.deploy(); 
  await token.deployed();
  console.log("Contract token deployed to address:", token.address);
  const marketplace = await Marketplace.deploy(token.address, 20);
  await marketplace.deployed();
  console.log("Contract marketplace deployed to address:", marketplace.address)
  await token.setMinterRole(marketplace.address)
}

main()
 .then(() => process.exit(0))
 .catch(error => {
   console.error(error);
   process.exit(1);
 });