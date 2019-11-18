#!/usr/bin/env node 

// Works for only single file Gists 

const program = require('commander')
const process = require('process')
const gists = require('./src/gists')
const htw = require('./src/htWrap')

const username='netrc'

const JSONParse = Symbol(); 
const NoParse = Symbol(); 

if (!('GI_GIST_PAT' in process.env) || process.env.GI_GIST_PAT=="") {
  console.log('no GI_GIST_PAT'); // maybe just on -v and -d 
  //exit
}
const PAT= process.env.GI_GIST_PAT
const basicAuthB64 = Buffer.from(`${username}:${PAT}`).toString('base64'); 
htw.setHeaders( 'Authorization', `Basic ${basicAuthB64}` )

const Usage = '[-h] [-d] { list | vi | cp } gistName'; 
program.version('0.1.0')    // -v for free // and --help
program.option('-d', 'debug info')
program.command('list').action(commandList)
program.command('cat').action(commandCat)
program.command('vi').action(commandVi)
program.parse(process.argv)

function commandList() {
  console.log('list');
  htw.getAndDo( gists.ListURL, JSONParse ).then( glist => {
    glist.forEach( g => console.log( gists.gToString(g) ) )
  }).catch( err => console.error(err) );
}

function commandCat() {
  console.log('doing xcat'); 
  htw.getAndDo( gists.ListURL, JSONParse ).then( glist => {
    const fURL = gists.getFURL( glist, process.argv[3] )   // here we can loop over argv
    console.log(`cat.then ${fURL}...`); 
    htw.getAndDo( fURL, "NoParse" ).then( d => {
      //console.log(`get furl, then...`);
      console.log(d)
    }).catch( err => console.error(err) );
  }).catch( err => console.error(err) );
}

function commandVi() {
  console.log('doing vi')
  console.log(`get ${process.argv[3]}`)
}
