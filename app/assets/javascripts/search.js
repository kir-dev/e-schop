document.addEventListener("turbolinks:load",function(){
    input=$("#scearched_prase");

    var options = {
        getValue: "name",
        url: function(phrase){
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
          onChooseEvent: function(){
            var url=input.getSelectedItemData().url
            input.val("");
            Turbolinks.visit(url)
            
           
          }
        }
      }

    input.easyAutocomplete(options);
});