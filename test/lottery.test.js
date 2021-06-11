const Lottery = artifacts.require("Lottery");

contract("Lottery", function ([deployer, user1, user2]) {
  let lottery;
  beforeEach(async () => {
    console.log("Before each");
    lottery = await Lottery.new();
  });

  it.only("getPot should return current pot", async () => {
    console.log("getPot should return current pot");
    let pot = await lottery.getPot();
    assert.equal(pot, 0);
  });

  describe("Bet", function () {
    it("should fail when the bet money is not 0.005 ETH", async () => {
        // Fail transaction


      }); 
    it("should put the bet to the bet queue with 1 bet", async () => {
        //bet

        //contract

    });
  });
});
