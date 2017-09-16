// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(){
  $(document).ready(function(){
    $("#searchForm").submit(function(event){
      event.preventDefault();
      setAjax($(this))
    });
    $("#newForm").submit(function(event){
      event.preventDefault();
      setAjax($(this))
    });
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
  });

  function setAjax(form){
    button = $(form.find(".submit-button")[0]);
    method = form.attr("method");
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
    function submitData(form,data){
      $.ajax({
        url: form.attr("action"),
        dataType:"json",
        contentType:"application/json",
        data: data,
        type: form.attr("method"),
        beforeSend: function(xhr,settings){
          button.attr("disabled",true);
          console.log(data);
        },
        complete: function(xhr,settings){
          console.log('disabled button');
          console.log(button);
          button.removeAttr("disabled",false);
        },
        success: function(result,textStatus,error){
          form[0].reset();
          console.log(result);
          console.log(textStatus);
          console.log(error);
        },
        error: function(xhr,textStatus,error){
          console.log(error);
        }
      });
    }
  }
})();
