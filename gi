#!/usr/bin/env node 

// Works for only single file Gists 

const https = require('https')
const process = require('process')
const fs = require('fs')
const gists = require('./src/gists')
//const simple = require('./src/simpleHTTP')
const axios = require('axios')

const username='netrc'
const ListURL='https://api.github.com/gists'

const JSONParse = Symbol(); 
const NoParse = Symbol(); 

const Usage = '[-h] [-d] { list | vi | cp } gistName'; 
const av = process.argv; 
if (av.length<=2) { 
  console.log('Usage: gcmd ${Usage}'); 
}
// Todo: collect global options -h -d -v -raw 

if (!('GI_GIST_PAT' in process.env) || process.env.GI_GIST_PAT=="") {
  console.log('no GI_GIST_PAT'); // maybe just on -v and -d 
  //exit
}

const PAT= process.env.GI_GIST_PAT
const basicAuthB64 = Buffer.from(`${username}:${PAT}`).toString('base64'); 

let options = {
  headers: { 
    'User-Agent': 'gi', 
    'Accept': 'application/json',
    'Authorization': `Basic ${basicAuthB64}`
  }
}

function getAndDoOld( Url, parseType, cb ) { 
  console.log(`old gad: ${Url}`)
  return axios.get(Url, options).then( async resp => {
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
  console.dir(options);
    const resp = await axios.get(Url, options);
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

switch (av[2]) {
  case 'list': 
      getAndDoOld( ListURL, JSONParse, gists.listGistsCB ).then( ret => {
        console.log( ret.join('\n') )
      });
    break; 
  case 'cat': //console.log('doing cat'); 
      getAndDoOld( ListURL, JSONParse, gists.catGistsCB ).then( ret => {
        console.log('cat.then...'); 
      });
    break; 
  case 'push': //console.log('doing push'); 
    readFilesAndPush(); 
    break; 
  default: 
    console.error(`unknown gist command: ${av[2]}`); 
    console.error(`Usage: gi ${Usage}`);
}
