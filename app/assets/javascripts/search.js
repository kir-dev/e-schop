document.addEventListener("turbolinks:load",function(){
    const goodSearchInput = $("#scearched_prase");

    const options = {
        getValue: "name",
        url: function(phrase) {
          return "/search?scearched_prase="+phrase
        },
        categories: [
            {   
                listLocation: "goods",
                header: "<strong>Termékek<strong>"
            }, 
            {   
                listLocation: "tags",
                header: "<strong>Cimke<strong>"           
             }
        ],

       
        list: {
          onChooseEvent: function() {

            const url=goodSearchInput.getSelectedItemData().url
            
            goodSearchInput.val("");
            Turbolinks.visit(url)
            
           
          }
        }
      }

    goodSearchInput.easyAutocomplete(options);
});