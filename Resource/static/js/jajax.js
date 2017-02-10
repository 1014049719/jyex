var jajax={
	xmlHttp:null,
	param:new Array(),
    abortHandle:null,
	init:function(){
		if(window.ActiveXObject){
			this.xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
		}else if(window.XMLHttpRequest){
			this.xmlHttp=new XMLHttpRequest();
		}
	},
	addVal:function(name,val){
		this.param.push(name+"="+val);
	},
	call:function(url,callback,method,asyn){
		this.xmlHttp.open(method,url,asyn);

		/*不使用缓存*/
		this.xmlHttp.setRequestHeader("Cache-Control","no-store");
		this.xmlHttp.setRequestHeader("Pragrma","no-cache");
		this.xmlHttp.setRequestHeader("Expires",0);
		/*不使用缓存END*/

		/*变量传递*/
		if(method=="post" || method=="POST"){
			this.xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		}
		/*变量传递END*/

		this.xmlHttp.onreadystatechange=function(){
			if(jajax.xmlHttp.readyState==4){
                if(jajax.abortHandle!=null)
                {
                    clearTimeout(jajax.abortHandle);
                    jajax.abortHandle=null;
                } 
				callback(jajax.xmlHttp,jajax.xmlHttp.status);
			}
		}
        this.abortHandle=setTimeout("jajax.xmlHttp.abort()",30000);
		this.xmlHttp.send(this.param.join('&'));
        //this.abortHandle=setTimeout("jajax.xmlHttp.abort()",30000);
	},
	parseJSON : function (filter) {
		try {
			if (/^("(\\.|[^"\\\n\r])*?"|[,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t])+?$/.test(filter)) {
				var j = eval('(' + filter + ')');
				if (typeof filter === 'function') {

					function walk(k, v) {
						if (v && typeof v === 'object') {
							for (var i in v) {
								if (v.hasOwnProperty(i)) {
									v[i] = walk(i, v[i]);
								}}}
								return filter(k, v);
					}
					j = walk('', j);
				}
				return j;
			}
		} catch (e) {
			// Fall through if the regexp test fails.
		}
	}
}