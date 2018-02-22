'use strict'

const fs = require('fs-extra')
const path = require('path')

const extractCert = ( file ) =>{
    const data = fs.readFileSync(path.join(__dirname, file))
    return Buffer.from(data).toString()
}

module.exports.modifyConfig = ( config ) =>{

    const caTLSCACert = extractCert(config.cas[0]['tlsCAcert'])
    const ordererTLSCACert = extractCert(config.channels[0]['orderer']['tlsCAcert'])
    const peer0TLSCert = extractCert(config.channels[0]['peers'][0]['tlsCAcerts'])
    const peer1TLSCert = extractCert(config.channels[0]['peers'][1]['tlsCAcerts'])

    const modifiedConfig = config
    modifiedConfig.cas[0]['tlsCAcert'] = caTLSCACert
    modifiedConfig.channels[0]['orderer']['tlsCAcert'] = ordererTLSCACert
    modifiedConfig.channels[0]['peers'][0]['tlsCAcerts'] = peer0TLSCert
    modifiedConfig.channels[0]['peers'][1]['tlsCAcerts'] = peer1TLSCert

    return modifiedConfig

}