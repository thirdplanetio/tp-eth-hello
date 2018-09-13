# ThirdPlanet Tutorial: Hello World Smart Contract

Author: [Fairiz Azizi](https://github.com/coderfi)

This tutorial will demonstrate deploying a HelloWorld smart contract to an Ethereum development node.

* install necessary prerequisites on an Ubuntu/Debian system
* install Ethereum development tools: `ganache-cli` and `truffle`
* start a private Ethereum development node using `ganache-cli`
* deploy a HelloWorld smart contract

## Download Source Code

    mkdir -p ~/dev
    cd ~/dev
    git clone https://github.com/thirdplanetio/tp-eth-hello
    cd ~/dev/tp-eth-hello

## Setup System Environment: Ubuntu[Xenial] / Debian

We need to make sure the following development packages are installed:

* `node >= 8.11.3`
* `npm >= 5.6`

It's possible that you have a much older version of such tools.
Be sure to follow these instructions in order to get the latest versions.

Note: For your convenience, the following script encapsulates all the commands in this section:

    # sudo is required!
    $ sudo bin/00_setup_system.sh

### System Libraries

Install some useful system tools and the build toolchain (i.e. gcc).

    $ sudo apt-get update
    $ sudo apt-get install -y curl gnupg2 software-properties-common build-essential

### App Development Tools

The following will install `nodejs`, as well as `npm`.

We will go ahead and install `yarn` as well, since it is commonly used with `nodejs` based projects.

    curl -fsSL https://deb.nodesource.com/setup_8.x | sudo bash -
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    sudo apt-get install -y --allow-unauthenticated nodejs yarn

### Check your versions

    $ npm --version
    # 6.4.1

    $ node --version
    # v8.12.0

## Setup Ethereum Development Tools

Run the following commands to setup the development environment.

Note: For your convenience, the following script encapsulates all the commands in this section:

    # no need for sudo
    $ bin/01_setup_eth_dev.sh

### Set global npm install path to user dir

    $ npm config set prefix=$HOME/node
    $ echo 'export PATH=$(npm config get prefix)/bin:$PATH' >> ~/.bashrc
    $ export PATH=$(npm config get prefix)/bin:$PATH

### Ethereum Development Tools

Install two commonly used tools for Ethereum development.

The `-g` flag will install them in your npm global directory that we specified above; e.g. `$HOME/node`

Tip: In the future, if you suspect tool version problems, try deleting `$HOME/node` so that you can effectively 'start over' and install these tools again.

    $ npm install -g truffle ganache-cli

### Check versions

    $ truffle version
    Truffle v4.1.14 (core: 4.1.14)
    Solidity v0.4.24 (solc-js)

    $ ganache-cli --version
    Ganache CLI v6.1.8 (ganache-core: 2.2.1)

## Ready!

Once your system and Ethereum tools are installed, you are ready to develop!

## Start a local development Ethereum node

Run this command to start your own private node:

    $ ganache-cli -p 8545
    ...
    Available Accounts
    ==================
    (0) 0xc35e9db4b7e397e0ae62196ed6449f3465a69fdd (~100 ETH)
    ...
    (1) 0x6292cb975619beb0b9d71bb88c07e511a5fdc8b4 (~100 ETH)
    ...
    Gas Price
    ==================
    20000000000

    Gas Limit
    ==================
    6721975

    Listening on 127.0.0.1:8545

## Setup HelloWorld Project

Let's create a simple smart contract.

Note: For your convenience, the following script encapsulates all the commands in this section:

    bin/02_setup_helloworld.sh

Run the following commands to initialize your truffle project:

    $ mkdir -p helloworld
    $ cd helloworld
    $ truffle init

This will create the following structure:

    ./contracts   # where your contracts will go
    ./migrations  # defines what contracts need to be deployed
    ./test        # your test files
    truffle-config.js  # your truffle development configuration
    truffle.js         # just delete this

### Delete truffle.js

We do not need this file, it is redundant with `truffle-config,js`.

    $ rm truffle.js

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

## HelloWorld Compile/Test/Migrate

Once we have some solidity, test and migration files, it's time to rock and roll!

### Compile the contracts

Next step is to compile the contract.

    $ truffle compile

### Testing

Run the following command to test the contract.

    # be sure ganache-cli is running!
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

Take a look at the `ganache-cli` output, you will see several transactions in the log:

    ...
    eth_sendTransaction
      Transaction: 0xc9178f55960577aec73af7d192b4cb74dc23249a254b7d9b423886156efdad9f
      Gas usage: 27008
      Block Number: 12
      Block Time: Wed Sep 12 2018 15:12:09 GMT-0700 (PDT)

The HelloWorld smart contract is now 'live'!

### Truffle Console

Instead of running the individual commands: `truffle {compile|test|migrate}`, it is convenient to enter the `truffle` shell:

    $ truffle console

This will show you a prompt:

    truffle(development)>

You can now run the `{compile|test|migrate}` commands

    truffle(development)> compile
    truffle(development)> test
    truffle(development)> migrate
    truffle(development)> <CTRL>-<d>

### Contract interaction samples

Using the truffle console, you can actually interact with the
smart contract with javascript!

Here is an example:

      truffle(development)>HelloWorld.deployed().then(function(instance){return instance.render.call();}).then(function(value){return value.toString()});
      'Hello World'

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
