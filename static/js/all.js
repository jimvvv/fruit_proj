// JavaScript Document
document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
WeixinJSBridge.call('hideOptionMenu');
});
document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
WeixinJSBridge.call('hideToolbar');
});

function updateproductnum(type, pprice, pnum, pid, unit, maxnum) {
    var pval = $("#pid_" + pid).val();
    var newnum = parseFloat(pval) + pnum;
    if (newnum >= 0 && newnum <= maxnum) {
        $("#pid_" + pid).val(newnum);
        var newprice = pprice * pnum;
        if(newnum === 0) {
            sessionStorage.removeItem("tmp_pid_" +pid);
            calculate();
        } else {
            refresh_cart(type, pprice, unit, pid);
        }
        //updateproductsumprice(newprice);
    }
};

function updateproductsumprice(price) {
    var proprice = $("#productcountprice").val();
    $("#productcountprice").val((parseFloat(proprice) + price).toFixed(2));
    proprice = $("#productcountprice").val();
    var productprice = parseFloat(proprice);
    var freeps = $("#free_ps_fee").val();
    var freepsfee = parseFloat(freeps);
    if (productprice >= freepsfee) {
        $("#ordercountprice").val(productprice.toFixed(2));
    } else {
        var psf = $("#psfee").val();
        var psfee = parseFloat(psf);
        $("#ordercountprice").val((psfee + productprice).toFixed(2));
    }
};

function refresh_cart(f_type, unit_price, unit, pid) {
    var pval = $("#pid_" + pid).val();
    var valid_item = "1";
    // Check browser support
    if (typeof(Storage) != "undefined") {
        var tmp_pid_value = sessionStorage.getItem("tmp_pid_" + pid);
        // Store
        if (tmp_pid_value) {
            tmp_item = tmp_pid_value.split("|");
            if (pval === "0" || pval === "") {
                $("#checkbox_"+pid).removeAttr("checked");
                $("#checkbox_"+pid).attr("disabled","true");
                tmp_item[5] = "0";
            } else {
                $("#checkbox_"+pid).removeAttr("disabled");
            }
            tmp_item[3] = pval;
            var item = tmp_item.join("|");
        } else {
            var item = [f_type, unit_price, unit, pval, pid, valid_item].join("|");
        }

        sessionStorage.setItem("tmp_pid_" + pid, item);
        //Compute the price for unit and total price
        calculate();
    } else {
        //Sorry, your browser does not support Web Storage;
    }
};

function getSessionData() {
    var tmp_split_item;
    x = get_tmp_pid_value();
    if(x.length){
        for(i in x) {
            tmp_split_item = x[i].split("|");
            $("#pid_" + tmp_split_item[4]).val(tmp_split_item[3]);
        }
        calculate();
    } else {
        //Do nothing
    }
}


function valStr(x) {
    var invalid_symbol = /[\*<%>\/]/g;
    var text_string = x.value;
    if (invalid_symbol.test(text_string) || (text_string === '' && x.id !== "comment")) {
        $("#" + x.id + "_warning").text("抱歉,请正确输入信息.");
        return false;
    } else {
        $("#" + x.id + "_warning").text("");
        return true;
    }
};

function valNum(x) {
    var valid_symbol = /^(\d{8}|\d{11}|\d{8}-\d{1,6})$/g;
    var text_string = x.value;
    if (!valid_symbol.test(text_string)) {
        $("#" + x.id + "_warning").text("抱歉,请正确联系电话.如有分机号,格式为xxx-xxx.");
        return false;
    } else {
        $("#" + x.id + "_warning").text("");
        return true;
    }
};

function checkShopCart() {
    if (get_valid_pid_value().length) {
        return true;
    } else {
        return false;
    }
}

function saveToStorage() {
    if (window.sessionStorage) {
        var tci = sessionStorage.getItem("tmp_client_info");
        if (tci) {
            var tciSplit = tci.split("|");
            var new_tci = [tciSplit[0], tciSplit[1], tciSplit[2], $("#comment").val()].join("|");
            sessionStorage.setItem("tmp_client_info", new_tci);
            return true;
        } else {
            var valFlag = validation();
            if (valFlag) {
                var client_info = [valFlag[0], valFlag[1], $("#area").val() + valFlag[2], $("#comment").val()].join("|");
                sessionStorage.setItem("tmp_client_info", client_info);
                return true;
            } else {
                return false;
            }
        }
    } else {
        // 不支持 sessionStorage，用 Dojo 实现相同功能
    }
};

function validation() {
    var receiver = document.getElementById("receiver");
    var number = document.getElementById("number");
    var address = document.getElementById("address");

    var verification1 = valStr(receiver);
    var verification2 = valNum(number);
    var verification3 = valStr(address);

    if (verification1 && verification2 && verification3) {
        return [receiver.value, number.value, address.value];
    } else {
        return false;
    }
};

function calculate() {
    var tmp_item_length = sessionStorage.length;
    var tmp_pid_list = [];
    var sum_price = 0;
    var tmp_number = 0;
    var key, result, value, single_price;
    for (var i = 0; i < tmp_item_length; i++) {
        var pat = /tmp_pid_\d/g;
        key = sessionStorage.key(i);
        result = pat.test(key);
        if (result) {
            value = sessionStorage.getItem(key);
            var tmp_item_info = value.split("|"); //tmp_item_info -> [fruit,unit_price,unit,quantity,pid,valid_item]
            single_price = parseFloat(tmp_item_info[1] * tmp_item_info[3]);
            $("#pid_" + tmp_item_info[4]).val(tmp_item_info[3]);
            //refresh the item_price if user change the quantity in shopcart
            $(".item_price_" + tmp_item_info[4]).text(single_price.toFixed(2));
            if (tmp_item_info[5] === "1" && tmp_item_info[3] !== "0") {
                $("#checkbox_" + tmp_item_info[4]).attr("checked", "true");
                sum_price = sum_price + single_price;
            } else if (tmp_item_info[3] === "0") {
                $("#checkbox_"+tmp_item_info[4]).attr("disabled","true");
            }
            tmp_number++;
        }
    }

    if(tmp_number) {
        sessionStorage.setItem("tmp_price", sum_price);
        $(".goShopcart").removeAttr("disabled");        
    } else {
        sessionStorage.removeItem("tmp_price");
        $(".goShopcart").attr("disabled","");
    }
    
    $(".total_price").text(sum_price.toFixed(2));
    
    if($("#number-badge").length) {
        $("#number-badge").text(tmp_number); 
    }
};

function get_tmp_pid_value() {
    var tmp_item_length = sessionStorage.length;
    var tmp_pid_list = [];
    var tmp_value = [];
    var parm = "";
    for (var i = 0; i < tmp_item_length; i++) {
        var key = sessionStorage.key(i);
        var pat = /tmp_pid_\d*/g;
        var result = pat.exec(key);
        if (result) {
            tmp_pid_list.push(result);
        }
    }

    for (j in tmp_pid_list) {
        tmp_value.push(sessionStorage.getItem(tmp_pid_list[j]));
    }

    return tmp_value;
};

function get_valid_pid_value() {
    var tmp_value;
    var valid_list = [];
    tmp_value = get_tmp_pid_value();
    if (tmp_value.length) {
        for (i in tmp_value) {
            var valid_flag = tmp_value[i].split("|")[5];
            if (valid_flag === "1") {
                valid_list.push(tmp_value[i]);
            }
        } 
    }
    return valid_list;
}