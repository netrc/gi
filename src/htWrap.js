
const axios = require('axios')

const JSONParse = Symbol(); 
const NoParse = Symbol(); 

let _options = {
  headers: { 
    'User-Agent': 'gi', 
    'Accept': 'application/json'
  }
}

const _setHeaders = function ( k, v ) {
  _options.headers[k] = v
}

const _getAndDoOld = function getAndDoOld( Url, parseType, cb ) { 
  console.log(`old gad: ${Url}`)
  return axios.get(Url, _options).then( async resp => {
      console.log(`old status: ${resp.status}`); 
  //    if (parseType == JSONParse) {
   //     resp.data = JSON.parse(resp.data); 
    //  }
      return cb(resp.data)
    }).catch( (err) => console.log(`Error: ${err.message}`) 
    ).finally( () => console.log('final') );
} 

async function getAndDoNew( Url, parseType, cb ) { 
  try {
  console.log(`new gad: ${Url}`);
  console.dir(_options);
    const resp = await axios.get(Url, _options);
    console.log(`status: ${resp.statusCode}`); 
    if (parseType == JSONParse) {
      resp.data = JSON.parse(resp.data); 
    }
    return ['a','b'];
    //return cb( resp.data );
  } catch (err) { 
      console.log(`Error: ${err.message}`) ;
  }
} 

module.exports = {
  setHeaders: _setHeaders,
  getAndDo: _getAndDoOld
}
