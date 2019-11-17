
// simple HTTP helper

const https = require('https')

const ListURL='https://api.github.com/gists'

const JSONParse = Symbol(); 
const NoParse = Symbol(); 

let _options = {
  headers: { 
    'User-Agent': 'gi', 
    'Accept': 'application/json' 
  }
}

const _setPAT = function ( username, pat ) {
  const basicAuthB64 = Buffer.from(`${username}:${pat}`).toString('base64'); 
  options.headers['Authorization'] = `Basic ${basicAuthB64}`;
}

const _getAndDo = function getAndDo( Url, parseType, cb ) { 
  console.log(`bad gad: ${Url}`); 
  //options.method = 'GET'; 
  https.get(Url, options, (resp) => { 
    let res_data = ''; 
    resp.on('data', (chunk) => { res_data += chunk }); 
    resp.on('end', () => {
      console.log(`status: ${resp.statusCode}`); 
      //if (parseType == JSONParse) {
      //  res_data = JSON.parse(res_data); 
      //}
      cb( res_data );
    });
  }).on('error', (err) => { console.log(`Error: ${err.message}`) })
}

module.exports = {
  setPAT: _setPAT,
  getAndDo: _getAndDo
}
