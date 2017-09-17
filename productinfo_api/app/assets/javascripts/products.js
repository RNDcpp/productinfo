// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(){
  $(document).ready(function(){
    //search form
    $("#searchForm").submit(function(event){
      event.preventDefault();
      setAjax($(this))
    });
    //new form is to create new product data
    $("#newForm").submit(function(event){
      event.preventDefault();
      setAjax($(this))
    });
    //new_product_pane_button is to open/close #newForm
    $("#new_product_pane_button").on('click',function(){
      form_pane=$("#new_product_form_container");
      if(form_pane.attr("hidden") !== undefined){// if new form is hidden
        form_pane.removeAttr("hidden");
        console.log("removeAttr hidden");
      }else{
        form_pane.attr("hidden",true);
        console.log("setAttr hidden")
      }
    });
    getAllProduct();
  });
  //get All Product Date with Ajax Get Request
  //get /products.json
  function getAllProduct(){
    $.ajax({
      url:"/products.json",
      contentType:"application/json",
      type:"get",
      success: function(result,textStatus,error){
        console.log(result);
        console.log(textStatus);
        console.log(error);
        products_list=$("#products-list");
        result.forEach(
            function(v,i,c_ary){
              productPane(v,products_list);
            });
      },
      error: function(xhr,textStatus,error){
        //TODO error handling
        console.log(error);
      }
    });
  }
  //convert object formatted product data to DOM Object and append specified parent DOM Object
  //product data has {"id","name","image_uri":{"url"},"cost","text"}
  function productPane(data,parent_pane){
    // if image_uri is not set, display specific image which means "no image data"
    data["image_uri"]=data["image_uri"]["url"];
    if(data["image_uri"]==null){
      data["image_uri"]="/no-image";
    }
    //a product_pane has information for each product
    product_pane=$("<div></div>",{"class":"product-pane"});
    product_pane.append($("<img>",{src: data["image_uri"],"class": "product-image"}));
    //product_info_pane has text information for each product and "edit/delete" buttons
    product_info_pane=$("<div></div>",{"class":"product-info-pane"});
    product_info_pane.append($("<p></p>",{"class":"product-name"}).text("name : "+data["name"]));
    product_info_pane.append($("<p></p>",{"class":"product-cost"}).text("cost : "+data["cost"]));
    product_info_pane.append($("<p></p>",{"class":"product-text"}).text("text : "+data["text"]));
    //product_buttons has edit and delete buttons
    product_buttons=$("<div></div>",{"class":"product-button-container"});
    //append edit button to product_buttons
    product_buttons.append($("<button></button>",{
      "class":"product-edit-button product-button",
      "data-id":data["id"],
      "data-cost":data["cost"],
      "data-text":data["text"],
      "data-image-uri":data["image_uri"],
      on:{
        click:function(event){
          //create edit form
          openEditForm({
            id:$(this).data("id"),
            cost:$(this).data("cost"),
            text:$(this).data("text"),
            image_uri:$(this).data("image-uri")
          });
        }
      }
    }).text("edit"));
    //append delete button to product_buttons
    product_buttons.append($("<button></button>",{
      "class":"product-delete-button product-button",
      "data-id":data["id"],
      on:{
        click:function(event){
          //create confirm 
          confirmDeleteProduct($(this).data("id"));
        }
      }
    }).text("delete"));

    product_info_pane.append(product_buttons);//append product_buttons to product_info_pane
    product_pane.append(product_info_pane);
    parent_pane.append(product_pane);//append product_pane to specified DOM object
  }

  //Create confirm pane for delete a product
  function confirmDeleteProduct(id){
    //TODO
  }
  //Create edit form pane to update a product
  function openEditForm(data){
    data["id"];
    data["name"];
    data["cost"];
    data["text"];
    data["image_uri"];
    //TODO
  }

  //implement ajax request to specified form
  function setAjax(form){
    button = $(form.find(".submit-button")[0]);
    method = form.attr("method");

    //convert image to base64
    //and append it to serialized form data array
    //(input type:file) is not included in form.serializeArray()
    function addFileData(ary,form,callback){
      file_input=form.find('[type="file"]')[0];
      reader=new FileReader();
      if(file_input.files[0]!==undefined){
        reader.onload = function(event){
          var e={};
          e["name"]=$(file_input).attr("name");
          e["value"]=event.target.result;
          console.log(event.target.result);
          ary.push(e);
          callback(ary,form);
        };
        reader.readAsDataURL(file_input.files[0]);
      }else{
        callback(ary,form);
      }
    }

    //convert form-data to processable formatted json
    function processData(ary,form){
      var data={};
      $.map(ary,function(v,i){
        console.log(v)
          nested_key=v["name"].match(/(?:\[).*(?=\])/)
          nested_object=v["name"].match(/.*(?=\[)/)
          if(nested_object===null){
            data[v["name"]]=v["value"];
          }else{
            console.log(nested_object)
              nested_key=nested_key[0].replace("[",""); // [name -> name
            if(data[nested_object]===undefined){
              data[nested_object]={};
            }
            data[nested_object][nested_key]=v["value"];
          }
      });
      submitData(form,JSON.stringify(data));
    }

    var ary=form.serializeArray();
    if(form.attr("method")=="get"){
      data=form.serialize();
      submitData(form,data);
    }else{
      addFileData(ary,form,processData);
    }

    //ajax request
    function submitData(form,data){
      $.ajax({
        url: form.attr("action"),
        dataType:"json",
        contentType:"application/json",
        data: data,
        type: form.attr("method"),
        beforeSend: function(xhr,settings){
          //prevent from double sending
          button.attr("disabled",true);
          console.log(data);
        },
        complete: function(xhr,settings){
          console.log('disabled button');
          console.log(button);
          //eneble submit button
          button.removeAttr("disabled",false);
        },
        success: function(result,textStatus,error){
          //reset form data
          form[0].reset();
          console.log(result);
          console.log(textStatus);
          console.log(error);
        },
        error: function(xhr,textStatus,error){
          //TODO error handling 
          console.log(error);
        }
      });
    }
  }
})();
