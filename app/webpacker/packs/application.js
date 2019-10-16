/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
function backgroundHeight() {
    console.log(document.body.scrollHeight + ",  ," + window.innerHeight)
    if (document.body.scrollHeight < window.innerHeight)
        document.getElementById("bg").style.height = window.innerHeight + "px";
    else
        document.getElementById("bg").style.height = document.body.scrollHeight + "px";
}

if (document.body.scrollHeight < window.innerHeight)
    document.body.style.height = window.innerHeight + "px";
var scrollHeight = document.body.scrollHeight;
window.addEventListener("resize", function () {
    if (document.body.scrollHeight < window.innerHeight || scrollHeight == document.body.scrollHeight)
        document.body.style.height = window.innerHeight + "px";
});
const myObserver = new ResizeObserver(backgroundHeight);

var body = document.body;
myObserver.observe(body);

var mutationObserver = new MutationObserver(function(mutations) {
    var container=document.getElementById("eac-container-index_input");
    var list;
   
    if(container!=null){
        list=document.getElementById("eac-container-index_input").firstChild;
    }
    if(list!=null){
        if(!list.classList.contains('autocomplet-list')){
            list.classList.add('autocomplet-list');
           }
    }
   
     
       
    });
  mutationObserver.observe(document.documentElement, {
    attributes: true,
    characterData: true,
    childList: true,
    subtree: true,
    attributeOldValue: true,
    characterDataOldValue: true
  });

