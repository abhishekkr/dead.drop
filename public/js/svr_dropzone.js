// server's dropzone specific js
//
function mk_dropzone(){ 
  $("div#stashr").dropzone({ url: "/stash", paramName: "dead_body"});
}
