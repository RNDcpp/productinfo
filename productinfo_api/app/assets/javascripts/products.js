// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(){
  $(document).ready(function(){
    //search form
    $("#searchForm").submit(function(event){
      event.preventDefault();
      setAjax($(this),{
        beforeSend:function(xhr,settings){},
        success:function(result,textStatus,error){
          products_list=$("#products-list");
          products_list.empty();
          result.forEach(function(v,i){
            productPane(v,products_list)
          });
        },
        complete:function(xhr,settings){},
        error:function(xhr,textStatus,error){}
      })
    });
    //new form is to create new product data
    $("#newForm").submit(function(event){
      event.preventDefault();
      setAjax($(this),{
        beforeSend:function(xhr,settings){},
        success:function(result,textStatus,error){getAllProducts()},
        complete:function(xhr,settings){$("#newForm")[0].reset()},
        error:function(xhr,textStatus,error){}
      })
    });
    //new_product_pane_button is to open/close #newForm
    $("#new_product_pane_button").on('click',function(){
      form_pane=$("#new_product_form_container");
      if(form_pane.attr("hidden") !== undefined){// if new form is hidden
        form_pane.removeAttr("hidden");
        console.log("removeAttr hidden");
      }else{
        form_pane.attr("hidden",true);
        console.log("setAttr hidden");
      }
    });
    //edit_product_pane_button is to close #editForm
    $("#edit_product_pane_button").on('click',function(){
      form_pane=$("#edit_product_form_container");
      if(form_pane.attr("hidden") === undefined){// if new form is hidden
        form_pane.attr("hidden",true);
      }
    });
    getAllProducts();
  });
  //get All Product Date with Ajax Get Request
  //get /products.json
  function getAllProducts(){
    $.ajax({
      url:"/products.json",
      contentType:"application/json",
      type:"get",
      success: function(result,textStatus,error){
        console.log(result);
        console.log(textStatus);
        console.log(error);
        products_list=$("#products-list");
        products_list.empty();
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
      "data-name":data["name"],
      "data-text":data["text"],
      "data-image-uri":data["image_uri"],
      on:{
        click:function(event){
          //create edit form
          openEditForm({
            id:$(this).data("id"),
            name:$(this).data("name"),
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
    /*
    data["id"];
    data["name"];
    data["cost"];
    data["text"];
    data["image_uri"];
    */
    $("#edit_product_form_container").removeAttr("hidden");
    edit_form=$("#editForm");
    edit_form[0].reset();
    edit_form.attr("action","/products/"+data["id"]+".json");
    edit_form.attr("method","put");
    ["name","cost","text"].forEach(function(v,i){
      if(data[v]){
        console.log(data[v])
        $("input#editForm_product_"+v).val(data[v]);
      }
    });
    edit_form.submit(function(event){
      event.preventDefault();
      setAjax($(this),{
        beforeSend:function(xhr,settings){},
        success:function(result,textStatus,error){getAllProducts()},
        complete:function(xhr,settings){edit_form[0].reset()},
        error:function(xhr,textStatus,error){}
      })
    });
  }

  //implement ajax request to specified form
  function setAjax(form,processes){
    button = $(form.find(".submit-button")[0]);
    method = form.attr("method");

    //convert image to base64
    //and append it to serialized form data array
    //(input type:file) is not included in form.serializeArray()
    function addFileData(ary,form,callback,processes){
      file_input=form.find('[type="file"]')[0];
      reader=new FileReader();
      if(file_input.files[0]!==undefined){
        reader.onload = function(event){
          var e={};
          e["name"]=$(file_input).attr("name");
          e["value"]=event.target.result;
          console.log(event.target.result);
          ary.push(e);
          callback(ary,form,processes);
        };
        reader.readAsDataURL(file_input.files[0]);
      }else{
        callback(ary,form,processes);
      }
    }

    //convert form-data to processable formatted json
    function processData(ary,form,processes){
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
            if(v["value"]!==null){
              data[nested_object][nested_key]=v["value"];
            }
          }
      });
      submitData(form,JSON.stringify(data),processes);
    }

    var ary=form.serializeArray();
    console.log(form.attr("method"))
    if(form.attr("method")=="get"){
      query=[];
      ary.forEach(function(v,i){
        if(v["value"]){
          query.push(v["name"]+'='+v["value"]);
        }
      });
      submitData(form,query.join('&'),processes);
    }else{
      addFileData(ary,form,processData,processes);
    }

    //ajax request
    function submitData(form,data,processes){
      $.ajax({
        url: form.attr("action"),
        dataType:"json",
        contentType:"application/json",
        data: data,
        type: form.attr("method"),
        beforeSend: function(xhr,settings){
          //prevent from double sending
          button.attr("disabled",true);
          if(processes['beforeSend']){
            processes['beforeSend'](xhr,settings);
          }
          console.log(data);
        },
        complete: function(xhr,settings){
          console.log('disabled button');
          console.log(button);
          //eneble submit button
          button.removeAttr("disabled",false);
          if(processes['complete']){
            processes['complete'](xhr,settings);
          }
        },
        success: function(result,textStatus,error){
          console.log(result);
          console.log(textStatus);
          console.log(error);
          if(processes['success']){
            processes['success'](result,textStatus,error);
          }
        },
        error: function(xhr,textStatus,error){
          //TODO error handling 
          console.log(error);
          if(processes['error']){
            processes['error'](xhr,textStatus,error);
          }
        }
      });
    }
  }
})();
