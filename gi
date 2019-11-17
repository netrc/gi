#!/usr/bin/env node 

// Works for only single file Gists 

const process = require('process')
const gists = require('./src/gists')
const htw = require('./src/htWrap')

const username='netrc'

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
    htw.getAndDo( gists.ListURL, JSONParse ).then( glist => {
      glist.forEach( g => console.log( gists.gToString(g) ) )
    }).catch( err => console.error(err) );
    break; 
  case 'cat': console.log('doing xcat'); 
    htw.getAndDo( gists.ListURL, JSONParse ).then( glist => {
      const fURL = gists.getFURL( glist, process.argv[3] )   // here we can loop over argv
      console.log(`cat.then ${fURL}...`); 
      htw.getAndDo( fURL, "NoParse" ).then( d => {
        //console.log(`get furl, then...`);
        console.log(d)
      }).catch( err => console.error(err) );
    }).catch( err => console.error(err) );
    break; 
  case 'vi': console.log('doing vi')
    console.log(`get ${process.argv[3]}`)
    break;
  case 'push': //console.log('doing push'); 
    readFilesAndPush(); 
    break; 
  default: 
    console.error(`unknown gist command: ${av[2]}`); 
    console.error(`Usage: gi ${Usage}`);
}
