document.addEventListener("turbolinks:load",function(){
    input2=$("#scearched_prase");

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

            var url=input2.getSelectedItemData().url
            
            input2.val("");
            Turbolinks.visit(url)
            
           
          }
        }
      }

    input2.easyAutocomplete(options);
});