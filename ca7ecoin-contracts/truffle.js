// See <http://truffleframework.com/docs/advanced/configuration>

// Allows us to use ES6 in our migrations and tests.
// require('babel-register');

module.exports = {
    networks: {
        development: {
            host: 'localhost',
            port: 8545,
            network_id: '*', // Match any network id
            gas: 1000000,
            gasPrice: 10000000000,
        }
    },
    rpc: {
        host: "localhost",
        gas: 4712388,
        port: 8545
    }
};
