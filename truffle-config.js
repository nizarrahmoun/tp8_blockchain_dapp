module.exports = {
  contracts_build_directory: "./src/artifacts/",
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id
    },
  },
  compilers: {
    solc: {
      version: "0.5.16", // Version compatible avec votre code Solidity
      optimizer: {
        enabled: false,
        runs: 200
      }
    }
  }
};
