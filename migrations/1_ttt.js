var TicTacToe = artifacts.require("TicTacToe");

module.exports = function (deployer) {
  // deployment steps
  deployer.deploy(TicTacToe);
};
