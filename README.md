# Tutorial: Hello World Smart Contract

Author: [Fairiz Azizi](https://github.com/coderfi)

This tutorial will demonstrate deploying a HelloWorld smart contract to an Ethereum development node.

* install necessary prerequisites on an Ubuntu system
* install Ethereum development tools: `ganache-cli` and `truffle`
* start a private Ethereum development node
* deploy a HelloWorld smart contract

## Setup System Environment: Ubuntu / Debian

We need to make sure the following development packages are installed:

* `node >= 8.11.3`
* `npm >= 5.6`

Run the commands specified in the following sections.

Alternatively, you can run the following script:

    sudo bin/00_setup_system.sh

### System Libraries

    sudo apt-get update
    sudo apt-get install -y curl gnupg2 software-properties-common build-essential

### App Development Tools

    curl -fsSL https://deb.nodesource.com/setup_8.x | sudo bash -
    sudo apt-get install -y nodejs

### Check your versions

    $ npm --version
    # 6.4.1

    $ node --version
    # v8.12.0

## Setup Ethereum Development Tools

Run the following commands to setup the development environment.

Alternatively, you can run the following script:

    # Note: sudo is not needed!
    $ bin/01_setup_eth_dev.sh

### Set global npm install path to user dir

    $ npm config set prefix=$HOME/node
    echo 'export PATH=$(npm config get prefix)/bin:$PATH' >> ~/.bashrc
    $ export PATH=$(npm config get prefix)/bin:$PATH

### Ethereum Development Tools

    $ npm install -g truffle ganache-cli

### Check versions

    $ truffle version
    Truffle v4.1.14 (core: 4.1.14)
    Solidity v0.4.24 (solc-js)

    $ ganache-cli --version
    Ganache CLI v6.1.8 (ganache-core: 2.2.1)

## Development Workflow

Once your system and Ethereum tools are installed, you are ready to develop!

### Start a local development Ethereum node

Run this command to start your own private node:

    $ ganache-cli -p 8545

## HelloWorld Smart Contract

Let's create a simple smart contract.

Run the following commands to initialize your truffle project:

    mkdir -p helloworld
    cd helloworld
    truffle init

This will create the following structure:

    ./contracts   # where your contracts will go
    ./migrations  # defines what contracts need to be deployed
    ./test        # your test files
    truffle-config.js  # your truffle development configuration
    truffle.js         # just delete this

### Delete truffle.js

We do not need this file, it is redundant with `truffle-config,js`.

    rm truffle.js

### `truffle-config.js`

Replace the `truffle-config.js` file with the following.

Note: One has been provided for you in the `tmpl/` directory.

This will define the `development` network to one listening locally on port 8545,
which happens to be the `ganache-cli` one that we started in the steps above.

see [Truffle Framework Configuration](http://truffleframework.com/docs/advanced/configuration>) for more information.

    module.exports = {
      networks: {
        development: {
          host: "127.0.0.1",
          port: 8545,     // NOTE: this matches the ganache-cli port number
          network_id: "*" // match any network id
    }}};

### `contracts/HelloWorld.sol`

Copy the following into `contracts/HelloWorld.sol`.

Note: One has been provided for you in the `tmpl/` directory.

This has a simple render function that returns the string "Hello World".

    pragma solidity ^0.4.24;
    contract HelloWorld {
      function render() public pure returns (string) {
        return 'Hello World';
    }}

### `test/TestHelloWorld.sol`

Copy the following into `test/TestHelloWorld.sol`.

Note: One has been provided for you in the `tmpl/` directory.

This makes sure that our contract's method says hello!

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

### `migrations/2_deploy_contracts.js`

Copy the following into `migrations/2_deploy_contracts.js`.

Note: One has been provided for you in the `tmpl/` directory.

This will tell the `truffle` migration script how to deploy our contract.

    const HelloWorld = artifacts.require("./HelloWorld.sol")
    module.exports = function(deployer) {
    	deployer.deploy(HelloWorld);
    };

### Compile the contracts

Next step is to compile the contract.

    $ truffle compile

### Testing

Run the following command to test the contract.

    $ truffle test

    TestHelloWorld
      ✓ testSaysHello (88ms)


    1 passing (547ms)

### Deploy to the development network

If all looks good, time to deploy!

Reminder: in the `truffle-config.js` file, we defined the `development` network to point
to our local `ganache-cli` port.

    $ truffle migrate --network development

    Using network 'development'.
    ...
    Running migration: 2_HelloWorld.js
    ...

## Conclusion and Follow ups

The above showed how to setup your development environment, create and deploy a simple contract.

The next demo will show what you could do to make a contract usable in a decentralized application!

# Troubleshooting

* Could not connect to your Ethereum client.

      Could not connect to your Ethereum client. Please check that your Ethereum client:
          - is running
          - is accepting RPC connections (i.e., "--rpc" option is used in geth)
          - is accessible over the network
          - is properly configured in your Truffle configuration file (truffle.js)

  Make sure `ganache-cli` is running.

# References

* [tp-dapp-sample](https://github.com/thirdplanetio/tp-dapp-sample) dApp Tutorial
* [Solidity v0.4.24](https://solidity.readthedocs.io/en/v0.4.24)
* [Ganache](https://truffleframework.com/ganache)
