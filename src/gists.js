
// gist API tools

const fs = require('fs')
const htw = require('./htWrap')

// TODO: func that does simple glist structure string format
const _gToString = function fToString ( g ) {
    const fname = Object.keys(g.files)[0];  // TODO: one file gist
    return `${fname} // (${g.public?'public':'private'}) ${g.description} - ${g.files[fname].language} - ${g.files[fname].size} bytes`;
}

const _gistNameFilter = function gistNameFilter( g, f ) { 
  const fname = Object.keys(g.files)[0]; 
  return fname===f; 
}

const _getFURL = function getFURL ( glist, fname ) {
  const fstruct = glist.filter( g => _gistNameFilter(g,fname) )
  // if fstruct.length != 1....
  const g = fstruct[0]
  // console.dir(g.files);
  const raw_url = g.files[fname].raw_url; 
  return raw_url;
}

module.exports = {
  ListURL: 'https://api.github.com/gists',
  gToString: _gToString,
  getFURL: _getFURL
}
