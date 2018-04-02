// See <http://truffleframework.com/docs/advanced/configuration>

// Allows us to use ES6 in our migrations and tests.
// require('babel-register');

module.exports = {
    networks: {
        development: {
            host: '127.0.0.1',
            port: 8545,
            network_id: '*', // Match any network id
            gas: 1000000,
            gasPrice: 10000000000,
        }
    },
    rpc: {
        host: "127.0.0.1",
        gas: 4712388,
        port: 8545
    }
};
