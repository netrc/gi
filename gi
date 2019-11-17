#!/usr/bin/env node 

// Works for only single file Gists 

const process = require('process')
const gists = require('./src/gists')
const htw = require('./src/htWrap')

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

htw.setHeaders( 'Authorization', `Basic ${basicAuthB64}` )

switch (av[2]) {
  case 'list': console.log('list');
      htw.getAndDo( ListURL, JSONParse, gists.listGistsCB ).then( ret => {
        console.log( ret.join('\n') )
      });
    break; 
  case 'cat': console.log('doing cat'); 
      htw.getAndDo( ListURL, JSONParse, gists.catGistsCB ).then( ret => {
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
