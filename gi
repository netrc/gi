#!/usr/bin/env node 

// Works for only single file Gists 

const https = require('https')
const process = require('process')
const fs = require('fs')

const username='netrc'
const PAT= process.env.GI_GIST_PAT
const ListURL='https://api.github.com/gists'

const JSONParse = Symbol(); 
const NoParse = Symbol(); 

const Usage = '[-h] [-d] { list | vi | cp } gistName'; 
const av = process.argv; 
if (av.length<=2) { 
  console.log('Usage: gcmd ${Usage}'); 
}

// Todo: collect global options -h -d -v -raw 

const basicAuthB64 = Buffer.from(`${username}:${PAT}`).toString('base64'); 
let options = {
  headers: { 
    'User-Agent': 'gi', 
    'Accept': 'application/json' 
  }
}

if (PAT) { // add pat 
  options.headers['Authorization'] = `Basic ${basicAuthB64}`;
} else {
  console.log('no GI_GIST_PAT'); // maybe just on -v and -d 
} 

function getAndDo( Url, parseType, cb ) { 
  console.log(`gad: ${Url}`); 
  //options.method = 'GET'; 
  https.get(Url, options, (resp) => { 
    let res_data = ''; 
    resp.on('data', (chunk) => { res_data += chunk }); 
    resp.on('end', () => {
      console.log(`status: ${resp.statusCode}`); 
      if (parseType == JSONParse) {
        res_data = JSON.parse(res_data); 
      }
      cb( res_data );
    });
  }).on('error', (err) => { console.log(`Error: ${err.message}`) })
} 

function listGistsCB ( glist ) { 
  glist.forEach( g => {
    const fname = Object.keys(g.files)[0]; 
    console.log(`${fname} // (${g.public?'public':'private'}) ${g.description} - ${g.files[fname].language} - ${g.files[fname].size} bytes`);
  }); 
}

function gistNameFilter( g, f ) { 
  const fname = Object.keys(g.files)[0]; 
  return fname===f; 
}

function catGist( d ) { // how do I know if it's json or not? 
  console.log('got something'); 
  console.log(JSON.stringify(0)); 
} 

function catGistsCB ( glist ) { 
console.log('catgist')
  av.slice(3).forEach( f => { 
    console.log(`got glist: looking for ${f}`);
    glist.filter( g => gistNameFilter(g,f) ).forEach( g => { 
      const raw_url = g.files[f].raw_url; 
      console.log(`found g for ${f} ${raw_url}`);
      getAndDo( raw_url, NoParse, catGist );
    }); 
  }); 
}

// TODO: ?? pushes each one individually; no mult-file gists 
function readFilesAndPush() {
  av.slice(3).forEach( async f => {
    console.log(`new gist ${f}`); 
    const fcontents = await fs.promises.readFile( f );
    //console.log(`done: ${fcontents}`); 
    let fobj = {
      description: `read ${f} and patch`,
      public: true, 
      files: {}
    }
    fobj['files'][f] = {
      contents: fcontents, 
      filename: f
    }
    console.log(`pushAndDo( ${f} )`);
  })
} 

switch (av[2]) {
  case 'list': //console.log('doing list'); 
    getAndDo( ListURL, JSONParse, listGistsCB ); 
    break; 
  case 'cat': //console.log('doing cat'); 
    getAndDo( ListURL, JSONParse, catGistsCB ); 
    break; 
  case 'push': //console.log('doing push'); 
    readFilesAndPush(); 
    break; 
  default: 
    console.error(`unknown gist command: ${av[2]}`); 
    console.error(`Usage: gi ${Usage}`);
}
