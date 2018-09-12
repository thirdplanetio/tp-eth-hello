pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HelloWorld.sol";

contract TestHelloWorld {
  function testSaysHello() public {
    HelloWorld inst = HelloWorld(DeployedAddresses.HelloWorld());
    Assert.equal(inst.render(), "Hello World", "did not say hello");
  }
}
