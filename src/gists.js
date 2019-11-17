
// gist API tools
const fs = require('fs')
const process = require('process')

const _listGistsCB = function listGistsCB ( glist ) { 
//console.log('inside _list');
  return glist.map( g => {
    const fname = Object.keys(g.files)[0]; 
//console.log(`lg: ${fname}`)
    return `${fname} // (${g.public?'public':'private'}) ${g.description} - ${g.files[fname].language} - ${g.files[fname].size} bytes`;
  }); 
  //console.dir(foo);
  //return foo;
}

const _gistNameFilter = function gistNameFilter( g, f ) { 
  const fname = Object.keys(g.files)[0]; 
  return fname===f; 
}

const _catOneGist = function catGist( d ) { // how do I know if it's json or not? 
  console.log('got something'); 
  //console.log(JSON.stringify(d)); 
  console.log(d); 
} 

const _catGistsCB = function catGistsCB ( glist ) { 
console.log('catgists')
  process.argv.slice(3).forEach( f => { 
    console.log(`got glist: looking for ${f}`);
    glist.filter( g => _gistNameFilter(g,f) ).forEach( g => { 
      const raw_url = g.files[f].raw_url; 
      console.log(`found g for ${f} ${raw_url} - now cat it`);
      //getAndDo( raw_url, "NoParse", _catOneGist );
    }); 
  }); 
}

module.exports = {
  listGistsCB: _listGistsCB,
  catGistsCB: _catGistsCB
}
