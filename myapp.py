#/usr/bin/env python
# -*- coding: utf-8 -*- 

#Python Libs
import hashlib
import re
import types

#Third Libs
import MySQLdb
from flask import Flask, request, g, redirect, render_template, url_for, jsonify
from lxml import etree

from werkzeug import secure_filename
from sae.storage import Connection
from sae.const import (MYSQL_HOST, MYSQL_HOST_S,
    MYSQL_PORT, MYSQL_USER, MYSQL_PASS, MYSQL_DB
)



#create the application
app = Flask(__name__)
app.debug = False

TOKEN='comergo13'
token = '345P@ssJ'


testOpenId2 = '234kdut'
FREE_PS_FEE = 0

#create the application
app = Flask(__name__)
app.config.from_object(__name__)
app.debug = app.config["DEBUG"]
STATUS_DICT = {
    '1' : u'等待',
    '2' : u'已发货',
    '3' : u'交易成功',
    '4' : u'退货中',
    '5' : u'退货成功',
    '6' : u'不予处理'
    }

def get_verification_code_from_wp():
    signature = request.args.get('signature')
    timestamp = request.args.get('timestamp')
    nonce = request.args.get('nonce')
    echostr = request.args.get('echostr')

    token = TOKEN
    tmpList = [token, timestamp, nonce]
    tmpList_sorted = sorted(tmpList)
    tmpString = "".join(tmpList_sorted)
    digest_signature = hashlib.sha1(tmpString).hexdigest()
    if digest_signature == signature:
        #return True
        return echostr
    else:
        return False

def get_pidlist():
    f_dic = {}  #{id:quantity}
    pid_list = []
    pattern = re.compile('pid_(.*)')
    request_keys = request.form.keys()
    for i in request_keys:
        result = re.search(pattern,i)
        if result:
            pid_list.append(result.group(0))
            quantity = request.form[result.group(0)]
            if int(quantity):
                f_dic[result.group(1)] = int(quantity)
        else:
            pass
    if f_dic:
        return f_dic
    else:
        return False
        
def calculate_order(x):
    tmp_items = [i.split("|") for i in x]
    items = [dict(f_type=j[0], unit_price=j[1], unit=j[2], quantity=j[3], pid=j[4]) for j in tmp_items]
    order_detail_list = ['fruit_','unit_','unit_price_','quantity_']
    sql_order_detail_list = []
    result = []
    order = []
    for i in range(0, len(items)):
        quantity = items[i]['quantity']
        result.append("'"+items[i]['f_type']+"'")
        result.append("'"+items[i]['unit']+"'")
        result.append(str(items[i]['unit_price']))
        result.append(str(quantity))

        order.append(dict(fruit=items[i]['f_type'], unit_price=items[i]['unit_price'], unit=items[i]['unit'], quantity=quantity))
        
        for j in order_detail_list:
            sql_order_detail_list.append(j+str(i+1))
    return (sql_order_detail_list, result,order)

def split_fruit_item(form_data):
    tmp_split_data = form_data.split("&&")      #Demo ["fruit|unit_price|unit|quantity|pid|checkflag", "fruit2|unit_price2|unit2|quantity2|pid2|checkflag2"]
    tmp_split_data_again = [i.split("|") for i in tmp_split_data]       #Demo [["fruit","unit_price", "unit", "quantity", "pid","checkflag"],["fruit2","unit_price2", "unit2", "quantity2", "pid2", "checkflag"]]
    tmp_list2dict = [dict(f_type=j[0], unit_price=j[1], unit=j[2], quantity=j[3], pid=j[4]) for j in tmp_split_data_again]
    return tmp_list2dict

def write_address_2_database(form_data, uid, cursor):
    new_name = form_data["receiver"]
    new_number = form_data["number"]
    new_address = form_data["area"] + form_data["address"]
    to_verify = [new_name, new_number, new_address]
    if valStr(to_verify):
        cursor.execute("SELECT id FROM user_info WHERE user_id = '%s'" %(uid))
        f_id = cursor.fetchone()[0]
        cursor.execute("INSERT INTO contact_info (`f_id`, `name`, `number`, `address`) values('%s','%s', '%s', '%s')" %(f_id, new_name, new_number, new_address))
        g.db.commit()
        return f_id
    else:
        return False

def get_id(uid):
    c = g.db.cursor()
    c.execute("SELECT `id` FROM user_info WHERE user_id='%s'" %(uid))
    user_info_id = c.fetchone()
    if user_info_id:
        return user_info_id[0]
    else:
        return False

def read_address_from_database(uid, cursor):
    cursor.execute("SELECT `id` FROM user_info WHERE user_id='%s'" %(uid))
    try:
        f_id = cursor.fetchone()[0]
        cursor.execute("SELECT `name`,`number`,`address`,`default_tag` FROM contact_info WHERE f_id = %s" %(f_id))
        return cursor.fetchall()
    except:
        return None

def read_description_from_database(id, cursor):
    cursor.execute("SELECT `number`,`desc` FROM fruit_desc WHERE f_id = %s" %(id))
    desc = [dict(did=row[0], desc=row[1]) for row in cursor.fetchall()]
    return desc

def get_specific_order(uid,oid):
    c = g.db.cursor()
    user_info_id = get_id(uid)
    c.execute("SELECT * FROM order_detail WHERE order_id='%s'" %(oid))
    item_history = [item for item in c.fetchone() if item]
    order_id = item_history[0]
    del item_history[0]     #delete the order_id from the list
    product_price = item_history[-1]
    del item_history[-1]    #delete the product_price from the list
    if len(item_history)%4:
        gift_content = item_history[-1]
        del item_history[-1]    #delete gift_content from the list
        gift_type = item_history[-1]
        del item_history[-1]    #delete gift_type from the list
    else:
        gift_content = None
        gift_type = None
    new_list = []
    for i in range(0,len(item_history),4):
        new_list.append(item_history[i:i+4])
    items = [dict(fruit=j[0], unit=j[1], unit_price=j[2], quantity=j[3]) for j in new_list]
    c.execute("SELECT receiver, contact_number, address, comment, express_fee, order_status FROM order_info WHERE id='%s' AND f_id='%s'" %(oid, user_info_id))
    user_info = c.fetchone()
    if user_info:
        status_desc = STATUS_DICT[str(user_info[5])]
        order_history = dict(customer=user_info[0],  contact_number=user_info[1], address=user_info[2], comment=user_info[3], express_fee=user_info[4], status = status_desc)
        if user_info[4] == 0:
            total_price = product_price
        else:
            total_price = product_price + user_info[4]
        return [items, order_history, order_id, product_price, total_price, gift_type, gift_content]
    else:
        return False

def xman_get_order(oid):
    c = g.db.cursor()
    c.execute("SELECT * FROM order_detail WHERE order_id='%s'" %(oid))
    item_history = [item for item in c.fetchone() if item]
    order_id = item_history[0]
    del item_history[0]     #delete the order_id from the list
    product_price = item_history[-1]
    del item_history[-1]
    new_list = []
    for i in range(0,len(item_history),4):
        new_list.append(item_history[i:i+4])
    items = [dict(fruit=j[0], unit=j[1], unit_price=j[2], quantity=j[3]) for j in new_list]
    c.execute("SELECT receiver, contact_number, address, comment, express_fee, order_status FROM order_info WHERE id='%s'" %(oid))
    user_info = c.fetchone()
    if user_info:
        status_desc = STATUS_DICT[str(user_info[5])]
        if user_info[5] in [1,2,4]:     #1,2,4 is standing for waiting, delivered and returning of goods.
            x = True
        else:
            x = False
        order_history = dict(customer=user_info[0],  contact_number=user_info[1], address=user_info[2], comment=user_info[3], express_fee=user_info[4], status = status_desc, x_man = x)
        if user_info[4] == 0:
            total_price = product_price
        else:
            total_price = product_price + user_info[4]
        return [items, order_history, order_id, product_price, total_price]
    else:
        return False

def valStr(x):
    pat = re.compile("[`;<>/*\\\\%]")
    if type(x) == types.ListType:
        __F = 0
        for i in x:
            if pat.search(i):
                __F = __F + 1
            else:
                pass
        if __F:
            return False
        else:
            return True
    else:
        if pat.search(x):
            return False
        else:
            return True

def code2hash(code):
    testToken = '368Jim@'
    return hashlib.sha1(code+testToken).hexdigest()
        
def isXman(uid):
    pair_code = "hello2Jimmy$"
    passwd = "f3f8d92970f0fe318a035a13a1e9422e14ef5267"
    x_code = hashlib.sha1(uid + pair_code).hexdigest()
    if passwd == x_code:
        return True
    else:
        return False
    
def xOrder(uid, status):
    if valStr(uid):
        if isXman(uid):
            querystr = request.args.get("oid",False)
            if querystr:
                if valStr(querystr):
                    single_order = xman_get_order(querystr)
                    return render_template('history_order_detail.html', items = single_order[0], infos = single_order[1], order_number = single_order[2], product_price = single_order[3], order_price = single_order[4], uid = uid, oid = querystr)
                else:
                    return u"请求错误"
            else:
                c = g.db.cursor()
                c.execute("SELECT `id` FROM order_info WHERE order_status = '%s'" %(status))
                order_id = [row[0] for row in c.fetchall()]
                return render_template('history_list.html',order_ids = order_id, url = request.base_url)
        else:
            return u"错误请求"
    else:
        return u'请求数据不存在!'

def get_img_url():
    img_dir = '/images'
    domain_name = 'fruitrepository'
    sae_storage_conn = Connection()
    tmp_bucket = sae_storage_conn.get_bucket(domain_name)
    dacl = tmp_bucket.generate_url('images/titlepic.jpg')
    return dacl

@app.before_request
def before_request():
    g.db = MySQLdb.connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB, port=int(MYSQL_PORT),charset='utf8')

 
@app.teardown_request
def teardown_request(exception):
    if hasattr(g, 'db'):
        g.db.close()

@app.route('/my_gift',methods=['POST'])
def gift():
    code = request.form.get("pro_code",False)
    if code:
        if valStr(code):
            pat = re.compile("^\d{10}$")
            if pat.search(code):
                gift_code = code2hash(code)
                c = g.db.cursor()
                c.execute("SELECT `gift_id`,`valid` FROM `promotion_code` WHERE hashcode = '%s'" %(gift_code))
                gift = c.fetchone()
                if gift == None:
                    return jsonify(gift_msg = u"客官,不好意思,你的密码无效,要不在店里逛逛?")
                else:
                    if gift[1] == 1:
                        c.execute("SELECT `type`, `1_fruit_type`, `2_coupon` FROM `promotion_gift` WHERE id = '%s'" %(gift[0]))
                        gift_type = c.fetchone()
                        if gift_type[0] == 1:
                            c.execute("SELECT `gift_fruit_type`, `gift_fruit_unit` FROM `gift_fruit` WHERE id = '%s'" %(gift_type[1]))
                            gift_fruit = c.fetchone()
                            #This is for fruit
                            return jsonify(gift_type = 1,
                                           gift_msg = u"赠送%s * %s" %(gift_fruit[0], gift_fruit[1]),
                                           gift_content = u"%s%s" %(gift_fruit[0], gift_fruit[1]))
                        elif gift_type[0] == 2:
                            #This is for coupon
                            return jsonify(gift_type = 2,
                                           gift_msg = u"立减%s元抵扣券" %(gift_type[2]),
                                           gift_content = gift_type[2])
                    elif gift[1] == 0:
                        return jsonify(gift_msg = u"客官,不好意思,你的密码无效,要不在店里逛逛?")
            return "Wrong"
        else:
            return "Error"


@app.route('/itemlist',methods=['GET'])
def show_item():
    tmp_user_id = request.args['user_id']
    if valStr(tmp_user_id):
        c = g.db.cursor()
        c.execute('SELECT * FROM fruit_type WHERE `enable`=1')
        items = [dict(pid=row[0], f_type=row[1], unit_price=row[2], unit=row[3]) for row in c.fetchall()]
        return render_template('item_list.html', fruits = items, user_id = tmp_user_id)
    else:
        return u"数据格式错误"

@app.route('/itemdetail',methods=['GET'])
def show_item_detail():
    c = g.db.cursor()
    querystr = request.args.get("detail-id")
    desc_list = read_description_from_database(querystr, c)
    if desc_list:
        return render_template('item_detail.html', pid = querystr, desc_list = desc_list)
    else:
        return u"数据格式错误"

@app.route('/shopcart',methods=['GET','POST'])
def my_shop_cart():
    c = g.db.cursor()
    shop_data = request.form.get("shop_item",False)
    uid_data = request.form.get("uid",False)
    address_data = request.form.get("address_item",False)
    if shop_data:
        if valStr(shop_data):
            shop_item_dict = split_fruit_item(shop_data)
        else:
            return u"数据格式错误"
    else:
        shop_item_dict = None

    if not address_data:
        if valStr(uid_data):
            address_set = read_address_from_database(uid_data, c)
            if address_set:
                #READ COMMON ADDRESS FROM DATABASE WHICH HAS AN ENABLE FLAG NAME COMMON
                default_info = [row for row in address_set if row[3] == 1]  #row[3] == 1 means it has a common address
                x=dict(name=default_info[0][0],number=default_info[0][1],address=default_info[0][2])  #default_info[0] is like [["Jimmy","12123123","No.13"]]
            else:
                x = None
        else:
            return u"数据格式错误"

    elif address_data:
        if valStr(address_data):
            address_data_list = address_data.split("|")
            x=dict(name=address_data_list[0],number=address_data_list[1],address=address_data_list[2])
        else:
            return u"数据格式错误"

    else:
        return u"数据格式错误"

    return render_template('shopcart.html', fruits = shop_item_dict, user_info = x, uid = uid_data)

@app.route('/address',methods=['GET','POST'])
def my_address():
    c = g.db.cursor()
    uid_data = request.args.get("user_id",False)
    if request.method == 'POST':
        
        ##WRITE TO DATABASE
        f_id = write_address_2_database(request.form, uid_data, c)
        if f_id:
            ##READ FROM DATABASE
            c.execute("SELECT `name`,`number`,`address`,`default_tag` FROM contact_info WHERE f_id = %s" %(f_id))
            x=[dict(name=row[0],number=row[1],address=row[2],default=row[3]) for row in c.fetchall()]
        else:
            return u"数据格式错误"
    else:
        if valStr(uid_data):
            ##READ FROM DATABASE
            address_set = read_address_from_database(uid_data, c)
            x=[dict(name=j[0],number=j[1],address=j[2],default=j[3]) for j in address_set]
        else:
            return u"数据格式错误"
    return render_template('address.html',user_info = x, uid = uid_data)

@app.route('/confirm_order',methods=['GET','POST'])
def my_order():
    tmp_order = request.form["order_detail"]
    tmp_gift = request.form["promotion_gift"]
    tmp_price = float(request.form["product_price"])
    user_id = request.args["user_id"]
    free_express = lambda x:x >= FREE_PS_FEE
    if valStr(tmp_order) and valStr(user_id):
        order_detail_dict = split_fruit_item(tmp_order)
        if tmp_gift:
            tmp_gift_list = tmp_gift.split("|")
            gift = dict(gift_type = tmp_gift_list[0], gift_content = tmp_gift_list[1], p_code = tmp_gift_list[2])
        else:
            gift = None

        #Initialize the first address for the new client
        if request.form.get("contact_detail",False):
            if valStr(request.form["contact_detail"]):
                tmp_new_address = request.form["contact_detail"].split("|");    #receiver, number, address 
                c = g.db.cursor()
                c.execute("SELECT `id` FROM user_info WHERE user_id = '%s'" %(user_id))
                f_id = c.fetchone()[0]
                insert_new_address = "INSERT INTO contact_info (`f_id`, `name`, `number`, `address`, `default_tag`) VALUES('%s', '%s', '%s', '%s', 1)" %(f_id, \
                tmp_new_address[0], tmp_new_address[1], tmp_new_address[2])
                c.execute(insert_new_address)
                g.db.commit()
            else:
                return u"数据格式错误"
        else:
            pass

        return render_template('order_confirm.html', fruits = order_detail_dict, uid = user_id, free = free_express(tmp_price), gift = gift)
    else:
        return u"数据格式错误"

@app.route('/myhistory/user/<uid>',methods=['GET'])
def show_history(uid=None):
    user_id = uid
    querystr = request.args.get('oid', False)
    post_submit = request.args.get('post_sub', False)
    if valStr(user_id):
        if querystr:
            if valStr(querystr):
                single_order = get_specific_order(user_id, querystr)
                if single_order:
                    if post_submit == 'True':
                        return render_template('order_submit.html', items = single_order[0], infos = single_order[1], order_number = single_order[2], product_price = single_order[3], order_price = single_order[4], g_type = single_order[5], g_content = single_order[6])
                    else:
                        return render_template('history_order_detail.html', items = single_order[0], infos = single_order[1], order_number = single_order[2], product_price = single_order[3], order_price = single_order[4], g_type = single_order[5], g_content = single_order[6])
                else:
                    return u"数据格式错误"
            else:
                return u"数据格式错误"
        else:
            c = g.db.cursor()
            c.execute("SELECT `id` FROM user_info WHERE user_id='%s'" %(user_id))
            f_id = c.fetchone()[0]
            c.execute("SELECT `id` FROM order_info WHERE f_id = '%s'" %(f_id))
            order_id = [row[0] for row in c.fetchall()]
            return render_template('history_list.html',order_ids = order_id, url = request.base_url)
    else:
        return u'错误请求'

@app.route('/submit',methods=['GET', 'POST'])
def submit_order():
    querystr = request.args
    form_data_client = request.form['client_detail']
    form_data_order = request.form['order_detail']
    product_price = request.form['product_price']
    form_data_gift = request.form.get('promotion_gift','')
    user_id = querystr['user_id']
    if valStr([form_data_client, form_data_order, product_price, form_data_gift, user_id]):
        pass
    else:
        return u'数据格式错误'


    tmp_user_info = form_data_client.split("|")    #[user, number, address, comment]
    tmp_item_info = form_data_order.split("&&")
    if form_data_gift:
        tmp_gift = form_data_gift.split("|")    #[type, content， promotion_code]
        tmp_gift[1] = "'" + tmp_gift[1] + "'"
    else:
        tmp_gift = None


    error = None
    c = g.db.cursor()
    if request.method == 'POST':
        customer = tmp_user_info[0]
        contact_number = tmp_user_info[1]
        address = tmp_user_info[2]
        comment = tmp_user_info[3]

        if customer and contact_number and address:
            if float(FREE_PS_FEE) <= float(product_price):
                express_fee = 0
            else:
                express_fee = 8
            order_price = float(product_price) + express_fee
            try:
                c.execute("SELECT id FROM user_info WHERE user_id = '%s'" %(user_id))
                f_id = c.fetchone()[0]
                c.execute('INSERT INTO order_info (`f_id`, `receiver`, `contact_number`, `address`, `comment`, `express_fee`) VALUES (%s, %s, %s, %s, %s, %s)', (f_id, customer, contact_number, address, comment, express_fee))
                c.execute('SELECT last_insert_id()')
                last_order_id = c.fetchone()[0]
                items = calculate_order(tmp_item_info)
                if tmp_gift:
                    insert_order_detail = 'INSERT INTO order_detail (order_id, %s, gift_type, gift_content, total_price) VALUES (%s, %s, %s, %s, %s)' %(','.join(items[0]),str(last_order_id), ','.join(items[1]), tmp_gift[0], tmp_gift[1], str(product_price))
                    hashcode = code2hash(tmp_gift[2])
                    c.execute("UPDATE `promotion_code` SET `valid` = 0 WHERE `hashcode` = '%s'" %(hashcode))
                else:
                    insert_order_detail = 'INSERT INTO order_detail (order_id, %s, total_price) VALUES (%s, %s, %s)' %(','.join(items[0]),str(last_order_id), ','.join(items[1]), str(product_price))
                c.execute(insert_order_detail)
                g.db.commit()
                return redirect(url_for('show_history', uid = user_id, oid = last_order_id, post_sub = True))
            except:
                return u'数据格式错误!'  
        else:
            return u'信息填写不正确!'
    else:
        return u'请求数据不存在!'

@app.route('/x_order/stat_change/xman/<uid>',methods=['POST'])
def change_status(uid=None):
    if valStr(uid):
        if isXman(uid):        #NEED Function isXman()
            querystr = request.args.get("oid",False)
            stat = request.form.get("status",False)
            if querystr and valStr(querystr):
                if stat and valStr(stat):
                    c = g.db.cursor()
                    c.execute("UPDATE order_info SET `order_status` = %s WHERE `id` = %s" %(stat, querystr))
                    g.db.commit()
                    return redirect(url_for('show_detail', uid = uid , oid =querystr))
            else:
                return u"请求错误"
        else:
            return u"错误请求"
    else:
        return u'请求数据不存在!'

@app.route('/x_order/waiting/xman/<uid>',methods=['GET'])
def get_waiting_order(uid=None):
    return xOrder(uid, '1')
    
@app.route('/x_order/delivering/xman/<uid>',methods=['GET'])
def get_delivering_order(uid=None):
    return xOrder(uid, '2')

@app.route('/x_order/complete/xman/<uid>',methods=['GET'])
def get_complete_order(uid=None):
    return xOrder(uid, '3')

@app.route('/x_order/refunding/xman/<uid>',methods=['GET'])
def get_refunding_order(uid=None):
    return xOrder(uid, '4')

@app.route('/x_order/fail/xman/<uid>',methods=['GET'])
def get_fail_order(uid=None):
    return xOrder(uid, '5')

@app.route('/x_order/filtered/xman/<uid>',methods=['GET'])
def get_filtered_order(uid=None):
    return xOrder(uid, '6')

@app.route('/x_order/detail/xman/<uid>',methods=['GET'])
def show_detail(uid=None):
    if valStr(uid):
        if isXman(uid):
            querystr = request.args.get("oid",False)
            if querystr:
                if valStr(querystr):
                    single_order = xman_get_order(querystr)
                    return render_template('history_order_detail.html', items = single_order[0], infos = single_order[1], order_number = single_order[2], product_price = single_order[3], order_price = single_order[4], uid = uid, oid = querystr)
                else:
                    return u"请求错误"
            else:
                return u"请求数据不存在"
        else:
            return u"错误请求"
    else:
        return u'请求数据不存在!'
    

@app.route('/',methods=['POST'])
def wechat_api():    
    #Receive the data(XML)from user(from weixin platform in fact)
    data_from_user = request.data
    #Parse the xml data
    xml_root = etree.fromstring(data_from_user)
    recv = {}
    for child in xml_root:
        recv[child.tag] = child.text

    open_id = recv['FromUserName']
    user_id = hashlib.sha1(open_id+token).hexdigest()
    
    mstype = recv['MsgType']
    if mstype == 'event':
        mscontent = recv['Event']
        if mscontent == 'subscribe':
            title = u'点击本消息，进入美果送'
            url = 'http://expressfruit.sinaapp.com/itemlist?user_id=%s' % (user_id)
            #description = '''您好！\n\n欢迎关注美果送，我们专注于为您提供优质的水果，足不出户，让您吃得开心，吃得放心！\n\n回复”1“，显示您的历史订单。\n\n回复其他内容，接入客服服务。'''
            description = u'''您好！\n\n欢迎关注美果送，我们专注于为您提供优质的水果，足不出户，让您吃得开心，吃得放心！\n\n回复”1“，显示您的历史订单。\n\n联系电话： 18101871242（小范）'''

            welcom_template = '''<xml>
            <ToUserName><![CDATA[%s]]></ToUserName>
            <FromUserName><![CDATA[%s]]></FromUserName>
            <CreateTime>12345678</CreateTime>
            <MsgType><![CDATA[news]]></MsgType>
            <ArticleCount>1</ArticleCount>
            <Articles>
            <item>
            <Title><![CDATA[%s]]></Title> 
            <Description><![CDATA[%s]]></Description>
            <Url><![CDATA[%s]]></Url>
            </item>
            </Articles>
            </xml>'''

            echodata = welcom_template %(open_id, recv['ToUserName'], title, description, url)

        elif mscontent == 'unsubscribe':
            pass

        return echodata

    elif mstype == 'text':
        c = g.db.cursor()
        c.execute("SELECT * FROM user_info WHERE open_id = '%s'" %(open_id))
        try:
            f_id = c.fetchone()[0]
        except:
            c.execute("INSERT INTO user_info (`open_id`, `user_id`) VALUES('%s', '%s')" %(open_id, user_id))
            g.db.commit()

        title1 = u'美味水果送'
        description1 = u'今日水果列表'
        picurl1 = 'http://expressfruit.sinaapp.com/static/css/images/titlepic_mini.jpg'
        url1 = 'http://expressfruit.sinaapp.com/itemlist?user_id=%s' % (user_id)

        title2 = u'我的历史订单'
        description2 = ''
        picurl2 = ''
        url2 = 'http://expressfruit.sinaapp.com/myhistory/user/' + user_id

        title3 = u'点击本消息，进入美果送'
        description3 = u'''您好！\n\n欢迎关注美果送，我们专注于为您提供优质的水果，足不出户，让您吃得开心，吃得放心！\n\n回复”1“，显示您的历史订单。\n\n联系电话： 18101871242（小范）'''
        picurl3 = ''


        receive_template = '''<xml>
            <ToUserName><![CDATA[%s]]></ToUserName>
            <FromUserName><![CDATA[%s]]></FromUserName>
            <CreateTime>12345678</CreateTime>
            <MsgType><![CDATA[news]]></MsgType>
            <ArticleCount>2</ArticleCount>
            <Articles>
            <item>
            <Title><![CDATA[%s]]></Title> 
            <Description><![CDATA[%s]]></Description>
            <PicUrl><![CDATA[%s]]></PicUrl>
            <Url><![CDATA[%s]]></Url>
            </item>
            <item>
            <Title><![CDATA[%s]]></Title> 
            <Description><![CDATA[%s]]></Description>
            <PicUrl><![CDATA[%s]]></PicUrl>
            <Url><![CDATA[%s]]></Url>
            </item>
            </Articles>
            </xml> '''
        
        receive_template2 = '''<xml>
            <ToUserName><![CDATA[%s]]></ToUserName>
            <FromUserName><![CDATA[%s]]></FromUserName>
            <CreateTime>12345678</CreateTime>
            <MsgType><![CDATA[text]]></MsgType>
            <Content><![CDATA[%s]]></Content>
            </xml>'''

        receive_template3 = '''<xml>
            <ToUserName><![CDATA[%s]]></ToUserName>
            <FromUserName><![CDATA[%s]]></FromUserName>
            <CreateTime>12345678</CreateTime>
            <MsgType><![CDATA[news]]></MsgType>
            <ArticleCount>1</ArticleCount>
            <Articles>
            <item>
            <Title><![CDATA[%s]]></Title> 
            <Description><![CDATA[%s]]></Description>
            <PicUrl><![CDATA[%s]]></PicUrl>
            <Url><![CDATA[%s]]></Url>
            </item>
            </Articles>
            </xml>'''   
    

        data_from_user = recv['Content']
        pat = re.compile("^%(\d{5})%$")
        pat2 = re.compile("^\d{10}$")
        admin_order = pat.search(data_from_user)
        promotion_tag = pat2.search(data_from_user)
        if admin_order:
            if admin_order.group(1) == '30246':
                url = 'Hello,Sir! What can I help you?\n\n'
                url = url + u'<a href="http://expressfruit.sinaapp.com/x_order/waiting/xman/%s">1.查看所有未处理订单</a>\n' %(user_id)
                url = url + u'\n<a href="http://expressfruit.sinaapp.com/x_order/delivering/xman/%s">2.查看所有发货中订单</a>\n' %(user_id)
                url = url + u'\n<a href="http://expressfruit.sinaapp.com/x_order/refunding/xman/%s">3.查看所有退货中订单</a>\n' %(user_id)
                echodata = receive_template2 % (open_id, recv['ToUserName'], url)
            else:
                echodata = receive_template2 % (open_id, recv['ToUserName'], u'对不起,请求无效')            
        elif promotion_tag:
            gift_code = code2hash(data_from_user)
            c = g.db.cursor()
            c.execute("SELECT `gift_id`,`valid` FROM `promotion_code` WHERE hashcode = '%s'" %(gift_code))
            gift = c.fetchone()
            if gift == None:
                echodata = receive_template2 % (open_id, recv['ToUserName'], u'客官,不好意思,你的密码无效,要不去店里逛逛?')
            else:
                if gift[1] == 1:
                    c.execute("SELECT `type`, `1_fruit_type`, `2_coupon` FROM `promotion_gift` WHERE id = '%s'" %(gift[0]))
                    gift_type = c.fetchone()
                    if gift_type[0] == 1:
                        c.execute("SELECT `gift_fruit_type`, `gift_fruit_unit` FROM `gift_fruit` WHERE id = '%s'" %(gift_type[1]))
                        gift_fruit = c.fetchone()
                        echodata = receive_template2 % (open_id, recv['ToUserName'], u'恭喜客官,你获得的是:\n %s * %s' %(gift_fruit[0], gift_fruit[1]))
                    elif gift_type[0] == 2:
                        echodata = receive_template2 % (open_id, recv['ToUserName'], u'恭喜客官,你获得的是:\n %s元抵用券' %(gift_type[2]))
                elif gift[1] == 0:
                    echodata = receive_template2 % (open_id, recv['ToUserName'], u'客官,不好意思,你的密码无效,要不去店里逛逛?')
        elif data_from_user == '1':
            echodata = receive_template3 % (open_id, recv['ToUserName'], title2, description2, picurl1, url2)
        else:
            c = g.db.cursor()
            c.execute('SELECT * FROM fruit_type_test WHERE `enable`=1')
            items = [dict(pid=row[0], f_type=row[1], unit_price=row[2], unit=row[3]) for row in c.fetchall()]
            txtMsg = u'\ue348\ue347\ue346\ue345\n欢迎光临<美果送>小店！\n【今日价格】\n\n'
            for i in items:
            	txtMsg = txtMsg + i.get('f_type') + i.get('unit') + ' ' + str(i.get('unit_price')) + u'元\n\n'
            echodata = receive_template2 % (open_id, recv['ToUserName'], txtMsg)


        return echodata

if __name__ == '__main__':
    app.run()
