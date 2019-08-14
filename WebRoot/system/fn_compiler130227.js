rowHeight=32;
colWidth=8;
String.prototype.myTrim=function(){
  return this.replace(/(^\s*)|(\s*$)/g,"");
};

function TField(page,name,spec,top,left,height,width,type,datafield,sql,style) {
    this.xpage=page,
    this.xname=name,
    this.xspec=spec,
    this.xtop=top,
    this.xleft=left,
    this.xheight=height,
    this.xwidth=width,
    this.xtype=type,
    this.xdatafield=datafield,
    this.xsql=sql,
    this.xstyle=style
};

function TGridField(name,spec,width,dec,type,align,style) {
    this.xname=name,
    this.xspec=spec,
    this.xwidth=width,
    this.xdec=dec,
    this.xtype=type,
    this.xalign=align,
    this.xstyle=style
};

function TTableField(name,datatype,computedcolumn,length,
  prec,dec,page,panel) {
  this.xname=name,
  this.xdatatype=datatype,
  this.xcomputedcolumn=computedcolumn,
  this.xlength=length,
  this.xprec=prec,
  this.xdec=dec,
  this.xpage=page,
  this.xpanel=panel
};

function TObject(xname,xtype,xlabel,xcommand,xaliasfields,xderivedfields,xname,xvalue) {
	this.xname=xname,this.xtype=xtype,this.xlabel=xlabel,this.xaliasfields=xaliasfields,
	this.xcommand=xcommand,this.xname=xname,this.xvalue=xvalue,this.xderivedfields=xderivedfields
};
  
function TMessage(xname,xexpression,xtype,xtag,xmessage){
	this.xname=xname,
	this.xexpression=xexpression,
	this.xtype=xtype,
	this.xtag=xtag,
	this.xmessage=xmessage
};

pckeyfield=pckeyspec='';
pcservicetype=pcservicefile='';
pcmtablespec=pcmtablename='';
pcrowheight=0;
pctitlerowheight=0;
pcfontheight=0;

pctitle=pcwintitle='';
pcwinheight=110;
pcwinwidth=110;
pctabtitle='';
pcpagecount=0;
pcpanelcount=0;
pcpageflag=0;  //是否出现过page标记
pcpanelflag=0;  //是否出现过panel标记
pcfilterfields='';
pcformfieldnames='';
pcformfieldsetstr='';
//tree
pctreenodefield='';
pcmgridfield='';
pctreetablename='';
pctreesql='';
pctreedatafields='';
pctreefilterfields='';
pctreefieldnames='';
pctreekeyfield='';
pctreekeyspec='';
pctreetitle='';
pctreefieldsetstr='';
pctreecolumnsetstr='';
pctreewidth=32*colWidth;
//grid
pcgridtablename='';
pcgridsql='';
pcgriddatafields='';
pcgridfieldnames='';
pcgridfilterfields='';
pcgridpagesize=0;
pcgridkeyfield='';  //grid主键字段名（不能缺省）
pcgridkeyspec='';   //grid主键miaoshu（可以能缺省）

//tab
pctabtablename='';
pctabsql='';
pctabdatafields='';
pctabfilterfields='';
pctabwidth=32*colWidth;
pctabkeyfield='';
pctabkeyspec='';
pctabtitle='';
pctabfieldsetstr='';
pctabtablefields='';
//生成控件的语句
pccheckmemusetstr='';
pcgridfieldsetstr='';
pcgridcolumnsetstr='';
//文件上传
pcfileuploadpath='';   //文件上传路径
pcimageheight=0;
pcimagewidth=0;
//数据替换与验证
pcreplacedim=new Array(new TMessage());
pcvalidruledim=new Array(new TMessage());
pctotalfielddim=new Array(new TMessage());
pcdtablespec=pcdtablename=new Array();
pcreftablespec=pcdtablename=new Array();
pcpagetitledim=new Array();
pcpaneltitledim=new Array();
pcreplacedim[0]=new TMessage();
pcvalidruledim[0]=new TMessage();
pctotalfielddim[0]=new TMessage();  
pcdtablespec[0]=pcdtablename[0]='';
pcreftablespec[0]=pcdtablename[0]='';
pcpagetitledim[0]='';
pcreplacestr='';
pcaliasfieldstr='';  //生成derived、alias控件
pagelabelwidth=new Array();
panellabelwidth=new Array();
panelpage=new Array();
pcobjects=new Array(new TObject());
pcobjects[0]=new TObject();
pcobjects[0].xname='';
pcobjects[0].xtype='';

function myGetTableFields(tablename) {
	var paramStr="tableName:'"+tablename+"'";
	var result=myAjaxSyncCall("fn_getFieldNames.jsp?tableName="+tablename,paramStr);
	return result
};

function myAjaxSyncCall(urlStr, paramsStr) {
    var obj;    
    var value;    
    if (window.ActiveXObject) {    
        obj = new ActiveXObject("Microsoft.XMLHTTP");    
    } else if (window.XMLHttpRequest) {    
        obj = new XMLHttpRequest();    
    }    
    obj.open("POST",urlStr,false);    
    obj.setRequestHeader("Content-Type","application/x-www-form-urlencoded");    
    //obj.send(paramsStr);
    obj.send(paramsStr);
    //var result = Ext.util.JSON.decode(obj.responseText);
    var result=obj.responseText;
    return result;
}   

function myGridParams(gridString) {  //返回grid参数[1]-标题,[2]-字段,[3]-对齐方式,[4]-宽度，【5】-type
	var result=[];
	gridString=gridString.myTrim();
	var index1=gridString.indexOf('/');
	var s1=s2=s3='';
	if (index1>=0) {
		s1=gridString.substring(0,index1).toLowerCase().myTrim();
		result[1]=gridString.substring(index1+1).myTrim(); //返回标题
	}else{	
		s1=gridString.toLowerCase();
		result[1]='';  //没有标题
	}	
	result[3]='';
	if (s1.indexOf('[@r]')>=0) {
		s1=s1.replace('[@r]','');
		result[3]='r';
	}
	if (s1.indexOf('[@c]')>=0) {
		s1=s1.replace('[@c]','');
		result[3]='c';
	}
	if (s1.replace('[@l]','')>=0) {
		s1=s1.replace('[@l]','');
		result[3]='l';
	}
	result[4]=0;
	var index1=s1.indexOf('[');
	var index2=s1.indexOf(']',index1+1);
	if (index1>=0 && index2>index1) {
		result[2]=s1.substring(index2+1).myTrim();  //字段名
		s1=s1.substring(index1+1,index2-index1).myTrim();
	}else{	
		result[2]=s1;  //字段名
	}
	result[5]='c';
	if (!isNaN(s1))  {
		result[4]=parseFloat(s1);
		//alert(parseFloat(s1));
	}else if (result[1]!=''){
	  	//  alert(s1);
		result[5]=s1.substring(0,1);
		s1=s1.substring(1);
		//alert(s1);
		if (s1!=''&&!isNaN(s1)) result[4]=parseInt(s1);
	}
	if (result[4]==0) result[4]=Math.max(2,result[1].length);
	return (result);
}

function myLoadXML(filename) {
    var xmlDoc = null;  
	if(window.ActiveXObject){
		xmlDoc=new ActiveXObject("Microsoft.XMLDOM");  //Microsoft.XMLHTTP,
	    xmlDoc.async=false;
		xmlDoc.load(filename);
		myCompiler(xmlDoc);
	}else if (window.XMLHttpRequest) { //webkit,Geckos,Op内核的(document.implementation && document.implementation.createDocument)  
		var xmlhttp=new window.XMLHttpRequest();
		//var xmlhttp=new XMLHttpRequest();   
		xmlhttp.open("GET", filename, false);//类型,文件名,是否缓存  
		xmlhttp.send(null);  
		xmlDoc = xmlhttp.responseXML;
		//xmlDoc=document.implementation.createDocument("","",null);
	    //xmlDoc.async=false;
		//xmlDoc.load(filename);		
		myCompiler(xmlDoc,'UN');  
	}
}

function myCompiler(xmlDoc,browserType) {
    var xmlRoot=xmlDoc.documentElement;
    var n1=xmlRoot.childNodes.length;
    var c=c1=c2=s1=s2=s3=s4=s5=s6='';
	var n=x1=x2=0;
	pcservicetype=xmlRoot.attributes[0].nodeValue;
	pageno=1;
	panelno=1;
	var i=j=k=0;
	for (i=0; i<n1; i++){
		var cnode=xmlRoot.childNodes[i];
		var xnode=xmlRoot.childNodes;
		s1=cnode.nodeName.toLowerCase();
		if (cnode.nodeType==1) {
			var n2=cnode.length;
      		var ctag=cnode.attributes;
	      	var xtagname=s1;
    	  	if (ctag!=null&&ctag.length==0) {
			  	s2=cnode.childNodes[0].nodeValue;
    		  	if (s2==null) s2='';
	        	x1=s2.indexOf(':');
    	    	c='';
        		if (x1>=0) {
          			c=s2.substring(x1+1);
	          		s2=s2.substring(0,x1); 
    	    	}
        		else c=s2;
        		s2=s2.myTrim();
        		c=c.myTrim();
        		x1=s2.indexOf('=');
        		if (x1>0) {
        			s3=s2.substring(0,x1);
        			s4=s2.substring(x1+1);
        		}else{
        			s3='';
        			s4='';
        		}	
        		if (s1=='title') pctitle=s2;
	        	else if (s1=='replace')  { 
					n=pcreplacedim.length;
    	      		pcreplacedim[n]=new TMessage();
        	  		pcreplacedim[n].xname=s3;
        	  		pcreplacedim[n].xexpression=s2;        	  		
          			pcreplacedim[n].xmessage=c;
        		}
        		else if (s1=='validation')  {
        			//替换特殊符号!>=,!>
        			s2=s2.replace('!>=','<');
        			s2=s2.replace('!>','<=');
        			s2=s2.replace(' and ',' && ');
        			s2=s2.replace(' or ','||');
    	      		n=pcvalidruledim.length;
	          		pcvalidruledim[n]=new TMessage();
          			pcvalidruledim[n].xname=s3;
        	  		pcvalidruledim[n].xmessage=c;
        	  		pcvalidruledim[n].xexpression=s2;
        		}
        		else if (s1=='totalfields')  {
	          		n=pctotalfielddim.length;
    	      		pctotalfielddim[n]=new TMessage();
        	  		pctotalfielddim[n].xexpression=s2;
          			pctotalfielddim[n].xmessage=c;
        		}
     		}else{
				var xtype=s1;
    	  		var xdatatype='';
      			var xname='';
      			var xfilepath='';
      			var xlabel='';
	      		var xfontsize='';
    	  		var xfontname='';
      			var xfontstyle='';
      			var xstyle='';
    	  		var xformat='';
	      		var xshorthandfield='';
      			var xpos='';
		    	var xsize='';
			    var xreportmargin='';  //printer margin
    	  		var xparent='';
			    var xitems='';
				var xdatafields='';
				var xderivedfields='';   //得到导出值
				var xaliasfields='';    //得到相同值
				var xindexfields='';
				var xfilterexp='';
      			var xtablename='';
      			var xtableid='';
	      		var xid='';
	      		var xreadonly='';
    	  		var xkeyfield='';
      			var xmasterfields='';
      			var xreffields='';
	      		var xtitlerowheight='';
			    var xrowheight='';
      			var xservicefile='';
      			var xkeyfield='';
      			var xaction='';
			    var xpage=0;
    	  		var xpanel=0;
    	  		var xvalue='';
    	  		var xmaxvalue='';
    	  		var xminvalue='';
    	  		var xdecimal=0;
    	  		var xemptytext='';
      			var xleft=0;
      			var xwidth=0;
    	  		var xtop=0;
      			var xheight=0;
      			var xmaxlength=0;
	      		var xpagesize=0;
      			var xlength=0;
      			var xlabelwidth=0;
	      		var xfidlength=0;
	      		var xvisible='';
    	  		var xtitle='';
      			var xfilterfields='';
      			var xdec=0;
	      		var xsql='';
    	  		var xsubtagname='';
    	  		var str='';
    	  		var strrpl=''; 
      			for (var j=0;j<ctag.length;j++) {
      				s3=ctag[j].name;
      				s4=ctag[j].value;
	      			s4=s4.replace(/(^\s*)|(\s*$)/g,"");
    	  			s5=s4.toLowerCase();
    	  			if (s4!='' && !isNaN(s4)) s6=parseFloat(s4);
    	  			else s6=0; 
				    if (s3=='label') xlabel=s4; 
      				else if (s3=='parent') xparent=s4;
      				else if (s3=='servicefile') xservicefile=s4;
      				else if (s3=='id') xid=s4;
	      			else if (s3=='table') xtablename=s4;
    	  			else if (s3=='tableid') xtableid=s4;
	      			else if (s3=='value') xvalue=s4;
	      			else if (s3=='maxvalue') xmaxvalue=s4;
	      			else if (s3=='minvalue') xminvalue=s4;
    	  			else if (s3=='format') xformat=s4;
      				else if (s3=='pos') xpos=s4;
      				else if (s3=='size') xsize=s4;
      				else if (s3=='decimal') xdecimal=s6;
	      			else if (s3=='pagemargin') xreportmargin=s4;
	      			else if (s3=='maxlength') xmaxlength=s6;
    	  			else if (s3=='fontsize') xfontsize=s4;
    	  			else if (s3=='items') xitems=s4;
      				else if (s3=='title') xtitle=s4;
	      			else if (s3=='sql') xsql=s4;
    	  			else if (s3=='filepath') xfilepath=s4;
      				else if (s3=='name') xname=s5;
      				else if (s3=='emplytext') xemptytext=s4;
      				else if (s3=='hint') xemptytext=s4;
      				else if (s3=='fontname') xfontname=s5;
      				else if (s3=='fontstyle') xfontstyle=s5;
      				else if (s3=='derivedfields') xderivedfields=s5;
      				else if (s3=='aliasfields') xaliasfields=s5;      				
      				else if (s3=='datafields') xdatafields=s5;
      				else if (s3=='filterfields') xfilterfields=s5;
      				else if (s3=='type') xtype=s5; 
	      			else if (s3=='datatype') xdatatype=s5;
    	  			else if (s3=='masterfields') xmasterfields=s5;
      				else if (s3=='referencefields') xreffields=s5;
      				else if (s3=='indexfields') xindexfields=s5;
      				else if (s3=='filter') xfilterexp=s5; 
	      			else if (s3=='style') xstyle=s5;
    	  			else if (s3=='readonly') xreadonly=s5;
    	  			else if (s3=='visible') xvisible=s5;    	  			
    	  			else if (s3=='hidden') xvisible=s5;    	  			
      				else if (s3=='keyfield') xkeyfield=s5;
      				else if (s3=='page') xpage=s6;
	      			else if (s3=='panel') xpanel=s6;
      				else if (s3=='labelwidth') xlabelwidth=s6;
      				else if (s3=='titlerowheight') xtitlerowheight=s6;
      				else if (s3=='rowheight') xrowheight=s6;      
	      			else if (s3=='pagesize') xpagesize=s6;
	      			
    	 		} //for j
       			c=c1=c2='';
       			x1=x2=0;
      			var xleft=0;
      			var xwidth=0;
    	  		var xtop=0;
      			var xheight=0;
	       		if (xpos!='') {
    	      		c=xpos;
        	  		x1=c.indexOf(',');
          			c1=c2='';
          			if (x1>=0) { 
	            		c1=c.substring(0,x1).myTrim(); 
    	        		c2=c.substring(x1+1).myTrim();
        	  		} else c1=c;
          			if (c1!='' && !isNaN(c1)) xtop=parseFloat(c1);
          			if (c2!='' && !isNaN(c2)) xleft=parseFloat(c2);
       			}   
	       		if (xsize!='') {
    	      		c=xsize;
        	  		x1=c.indexOf(',');
          			c1=c2='';
          			if (x1>=0) { 
            			c1=c.substring(0,x1).myTrim(); 
	            		c2=c.substring(x1+1).myTrim();
    	      		}
        	  		else c1=c;
          			if (c1!='' && !isNaN(c1)) xheight=parseFloat(c1);
          			if (c2!='' && !isNaN(c2)) xwidth=parseFloat(c2);
	       		}	
    	   		if (xrowheight!='')  pcrowheight=parseFloat(xrowheight);
       			if (xtitlerowheight!='') pctitlerowheight=parseFloat(xtitlerowheight);
       			if (xfontsize!='') pcfontheight=-parseInt(xfontsize)*4/3;
    		    if (xpagesize==0) xpagesize=20;
    		    //if (xwidth<=0) xwidth=14;
    		    if (xmaxlength==0&&xwidth>0) xmaxlength=xwidth;
    	    	//开始分析标签
		        var n=pcobjects.length;
		        //alert('xtagname='+xtagname);
        		pcobjects[n]=new TObject();
     			if ((xtagname=='table')||(xtagname=='mastertable')) {
       				pcmtablename=xname;
	       			pcmtablespec=xlabel;
    	 		}else if (xtagname=='detailtable') {
       				pcdtablename[pcdtablename.length]=xtablename;
       				pcdtablespec[pcdtablespec.length]=xlabel;
	     		}else if (xtagname=='referencetable') {
    	   			pcreftablename[pcreftablename.length]=xtablename;
       				pcreftablespec[pcreftablespec.length]=xlabel;
     			}else if (xtagname=='tabform') {
     				pctabtablename=xtablename;
	     			pctabsql=xsql;
    	 			pctabdatafields=xdatafields;
    	 			pctreefilterfields=xfilterfields;
    	 			pctreetitle=xtitle;
    	 			if (xwidth>0) pctreewidth=xwidth*colWidth;
    	 			if (xkeyfield.indexOf('/')>0) {
     					pctreekeyfield=xkeyfield.substring(0,xkeyfield.indexOf('/'));
     					pctreekeyspec=xkeyfield.substring(xkeyfield.indexOf('/')+1);
     				}else{
     					pctreekeyfield=xkeyfield;
     					pctreekeyspec='';
     				}
     				//生成tree的各个列
     				pctreedatafields='cid;text;flag;'+pctreedatafields;
     				var tmpStr=pctreedatafields.split(';');
					pctreefieldsetstr='';
					for (k=0;k<tmpStr.length;k++) {
						pctreefieldsetstr=pctreefieldsetstr+",{name:'"+tmpStr[k]+"',type:'string'}";
					}//tabform处理结束
					if (xfilterfields!='') pcfilterfields=xfilterfields;
					else pcfilterfields=pctabdatafields;					          			
     			}else if (xtagname=='tree' || xtagname=='treegrid') {
					//处理tree开始     			
     				pctreetablename=xtablename;
	     			pctreesql=xsql;
    	 			pctreedatafields=xdatafields;
    	 			pctreedatafields='cid;text;flag;'+pctreedatafields;
    	 			pctreetitle=xtitle;
    	 			if (xwidth>0) pctreewidth=xwidth*colWidth;
    	 			if (xkeyfield.indexOf('/')>0) {
     					pctreekeyfield=xkeyfield.substring(0,xkeyfield.indexOf('/'));
     					pctreekeyspec=xkeyfield.substring(xkeyfield.indexOf('/')+1);
     				}else{
     					pctreekeyfield=xkeyfield;
     					pctreekeyspec='';
     				}
     				//生成tree的各个列
					pctreefieldsetstr='';
					pctreecolumnsetstr='';
					pctreefieldnames='';
					tmpStr=xdatafields.split(';');
					var xdatafields1='';  //记录有标题的列名称和标题
					for (var k=0;k<tmpStr.length;k++) {
						var tmp=myGridParams(tmpStr[k]);   //[@c][n10]field/产品12;
						pctreefieldnames=pctreefieldnames+";"+tmp[2].toLowerCase();
						if (tmp[1]!='') {  //存在标题的话
							if (k==0) {	//第一列节点树展开					   
								tmpStr1="{xtype:'treecolumn',text:'<center>"+tmp[1]+"</center>',";
							} else {
								tmpStr1="{text:'<center>"+tmp[1]+"</center>',";
							}								
							if (tmp[5]=='n') {
								tmpStr1=tmpStr1+"renderer:function(value){";
								tmpStr1=tmpStr1+"	return '<div align=\"right\">'+value+'</div>';";
	        					tmpStr1=tmpStr1+"		},";							
							}
				    		tmpStr1=tmpStr1+"sortable:false,menuDisabled:true,enableColumnMove:false,width:"+tmp[4]*colWidth+",dataIndex:'"+tmp[2]+"'}";
				    		//tmpStr1=tmpStr1+";";
					    	pctreecolumnsetstr=pctreecolumnsetstr+','+tmpStr1;
					    	xdatafields1=xdatafields1+";"+tmp[2]+"/"+tmp[1]; 
						}
    	 			}
    	 			//定义过滤的下拉菜单
	     			if (xfilterfields!='') pcfilterfields=xfilterfields;
	     			else if(xdatafields1!='') pcfilterfields=xdatafields1.substring(1);
	     			//没有设置过滤列时，选择grid中的所有列过滤
    	 			pctreefilterfields=pcfilterfields;
					tmpStr1='cid;text;flag;level;parentnodeid;isparentflag'+pctreefieldnames;
					if (pctreefieldnames!='') pctreefieldnames=pctreefieldnames.substring(1);
	     			var tmpStr=tmpStr1.split(';');
					pctreefieldsetstr='';
					for (k=0;k<tmpStr.length;k++) {
						pctreefieldsetstr=pctreefieldsetstr+",{name:'"+tmpStr[k]+"',type:'string'}";
					}
					if (xtagname=='tree' && pctreesql.toLowerCase().indexOf(' nodetext')<0) {
						pctreecolumnsetstr=''; //不按列显示节点
						tmpStr1='';
		     			var tmpStr=pctreefieldnames.split(';');
						for (k=0;k<tmpStr.length;k++) {
							if (tmpStr1!='') tmpStr1=tmpStr1+"+' '+";
							tmpStr1=tmpStr1+'rtrim(isnull('+tmpStr[k]+",''))";
						} 
						tmpStr1=tmpStr1+' as nodetext';
						pctreesql='select '+tmpStr1+','+pctreesql.substring(6);
						//alert(pctreesql);	
					}	
					
					//treegrid处理结束   				
     			}else if (xtagname=='grid') {
     				pcgridtablename=xtablename; 
     				pcgridsql=xsql;
     				if (xkeyfield.indexOf('/')>0) {
     					pcgridkeyfield=xkeyfield.substring(0,xkeyfield.indexOf('/'));
     					pcgridkeyspec=xkeyfield.substring(xkeyfield.indexOf('/')+1);
     				}else{
     					pcgridkeyfield=xkeyfield;
     					pcgridkeyspec='';
     				}
	     			pcgriddatafields=xdatafields;
    	 			pcgridpagesize=xpagesize;
        			//生成grid各列
        			pcgriddatafields=xdatafields;
					pcgridfieldnames="'sysRowNumber'";
					pcgridcolumnsetstr='';
					tmpStr=pcgriddatafields.split(';');
					var xdatafields1='';  //记录有标题的列名称和标题
					for (var k=0;k<tmpStr.length;k++) {
						var tmp=myGridParams(tmpStr[k]);   //[@c][n10]field/产品12;
						pcgridfieldnames=pcgridfieldnames+",'"+tmp[2]+"'";
						if (tmp[1]!='') {  //存在标题的话
							//tmpStr1="var tmpItem={text:'<center>"+tmp[1]+"</center>',";
							tmpStr1="{text:'<center>"+tmp[1]+"</center>',";
							if (tmp[5]=='n') {
								tmpStr1=tmpStr1+"renderer:function(value){";
								tmpStr1=tmpStr1+"	return '<div align=\"right\">'+value+'</div>';";
	        					tmpStr1=tmpStr1+"		},";							
							}
				    		tmpStr1=tmpStr1+"sortable:false,menuDisabled:true,enableColumnMove:false,width:"+tmp[4]*colWidth+",dataIndex:'"+tmp[2]+"'}";
				    		//tmpStr1=tmpStr1+";";
					    	pcgridcolumnsetstr=pcgridcolumnsetstr+','+tmpStr1;
					    	xdatafields1=xdatafields1+";"+tmp[2]+"/"+tmp[1]; 
						}
    	 			}
    	 			//定义过滤的下拉菜单
	     			if (xfilterfields!='') pcfilterfields=xfilterfields;
	     			else if(xdatafields1!='') pcfilterfields=xdatafields1.substring(1);
	     			pcgridfilterfields=pcfilterfields;
      			}else if (xtagname=='page') {
         			if (!isNaN(xname)) pcpagetitledim[parseInt(xname)]=xtitle;
         			else pcpagetitledim[pcpagetitledim.length]=xtitle;
	     		}else if (xtagname=='panel') {
    	     		if (!isNaN(xname)) pcpaneltitledim[parseInt(xname)]=xtitle;
        	 		else pcpaneltitledim[pcpaneltitledim.length]=xtitle;
	     		}	
        		if (!isNaN(xpage)) xpage=parseInt(xpage);
        		else xpage=0; 
        		if (!isNaN(xpanel)) xpanel=parseInt(xpanel);
        		else xpanel=0;
        		if (xpage==0 && xpanel==0) xpage=1;
    	    	if (!isNaN(xlabelwidth)) xlabelwidth=parseInt(xlabelwidth)*colWidth;
    	    	//if (xlabelwidth==0) xlabelwidth=8*colWidth; 
        		pcobjects[n].xtype=xtype;
        		pcobjects[n].xpage=xpage;
        		pcobjects[n].xpanel=xpanel;
        		pcobjects[n].xname=xname;
        		pcobjects[n].xvalue=xvalue;  //记录系统变量#sys
        		pcobjects[n].xcommand='';
        		pcobjects[n].xaliasfields=xaliasfields;
	        	//生成控件
	        	if (xdatafields!='') var xfielddim=xdatafields.split(';');
	        	else var xfielddim=[];
	        	if (xderivedfields!='') var xderiveddim=xderivedfields.split(';');
	        	else var xderiveddim=[];
	        	if (xaliasfields!='') var xaliasdim=xaliasfields.split(';');
	        	else var xaliasdim=[];
	        	if (xtype!='page' && xtype!='panel' && xlabelwidth==0) {
	        		//对page和panel没有注明的控件，其labelwidth值取容器
	        		if (xpanel>0 && panellabelwidth[xpanel]>0) xlabelwidth=panellabelwidth[xpanel];
	        		else if (xpage>0 && pagelabelwidth[xpage]>0) xlabelwidth=pagelabelwidth[xpage];
	        		if (xlabelwidth==0) xlabelwidth=8*colWidth;
	        	}
	        	if (xtype=='page'){
	        		pcwinwidth=Math.max(pcwinwidth,xwidth*colWidth);
	        		pcwinheight=Math.max(pcwinheight,xheight*rowHeight);
	        	 	if (xlabelwidth==0) xlabelwidth=8*colWidth;
	        		str="var myForm"+pageno+"=Ext.create('Ext.form.Panel',{";
					str=str+"frame:false,bodyStyle:'padding:5 5 5 5',border:false,layout: 'absolute',";
					if (xwidth>0)  str=str+"width:"+xwidth*colWidth+",";
					if (xheight>0) str=str+"height:"+xheight*rowHeight+",";
					//str=str+"listeners:{ beforeshow:function(){ alert(119); } },";
					str=str+"fieldDefaults:{";
					str=str+"	labelAlign:'right',";
					if (xlabelwidth>0) str=str+"	labelWidth:"+xlabelwidth+",";
            		str=str+"	labelSeparator: '',";
            		str=str+"	msgTarget: 'qtip' }});";
            		if (xtitle!=''){
						str=str+"var myPanel"+pageno+"=Ext.create('Ext.panel.Panel',{";
						str=str+"	title:'&nbsp;"+xtitle+"',";
	    				str=str+"	containerScroll:true,";
	    				str=str+"	collapsible: true,";
						str=str+"	items:[myForm"+pageno+"]});";
						pcpageflag=1;
            		}
            		pagelabelwidth[pageno]=xlabelwidth;
    	        	pageno=pageno+1;
	    	    	pcobjects[n].xcommand=str;
	        	}else if (xtype=='panel') {
					if (xlabelwidth==0) xlabelwidth=8*colWidth;
					str="var myFieldSet"+panelno+"={xtype:'fieldset',id:'myFieldSet"+panelno+"',name:'myFieldSet"+panelno+"',title:'&nbsp;"+xtitle+"',";
					str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight+",width:"+xwidth*colWidth+",height:"+xheight*rowHeight+",";
        	    	str=str+"labelWidth:"+xlabelwidth+",";
    	       		str=str+"layout: 'absolute', defaultType:'textfield'};";
    	       		str=str+"myForm"+xpage+".add(myFieldSet"+panelno+");";
    	       		panellabelwidth[panelno]=xlabelwidth;
    	       		panelpage[panelno]=xpage;
            		pcobjects[n].xcommand=str;
					panelno=panelno+1;
	        	}else if(xtype=='combobox'){
					if (xsql==''&& xtablename=='') {  //静态数据
						var xitemdim=xitems.split(';'); //取选项
						str="var comboboxStore_"+xname+"=new Ext.data.SimpleStore ({";
						str=str+" fields: ['"+xname+"'],";
						str=str+" data: [";
						for (k=0;k<xitemdim.length;k++) {
							if (k>0) str=str+",";
							str=str+"['"+xitemdim[k]+"']"
						}						  
						str=str+"]});";
					}else{
						if (xsql=='') xsql='select * from '+xtablename;
						str=" var comboboxStore_"+xname+"=Ext.create('Ext.data.Store',{";
   						str=str+" 	fields: [{type:'string',name:'"+xname+"'}";
   						for (k=0;k<xderiveddim.length;k++) {
	   						str=str+",{type:'string',name:'"+xderiveddim[k]+"'}";
	   					}	
   						str=str+" 	],";
   						str=str+" 	proxy: {";
    					str=str+"     	type: 'ajax',";
    					str=str+'      	extraParams:{sqlString:"'+xsql+'"},';
    					str=str+"      	url: 'fn_getComboxData.jsp',";
    					str=str+' 		reader: {';  
						str=str+" 			data:'totalCount',";  
  						str=str+" 			type: 'json',";  
  						str=str+" 			root: 'result'";  
  						str=str+' 		}'; 
  						str=str+" 	}";
    					str=str+" });";
   					}
    				str=str+"var tmp={ xtype:'combobox',fieldLabel:'"+xlabel+"',id:'"+xname+"',name:'"+xname+"',editable:false,store:comboboxStore_"+xname+",";
					str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight+",width:"+(xwidth*colWidth+xlabelwidth+16)+",";
					if (xlabel=='') str=str+"hideLabel:true,";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
					str=str+"lazyRender: false,mode: 'local',typeAhead: true,triggerAction: 'all',enableKeyEvents:true,selectOnTab:true,"; 
   					str=str+"displayField:'"+xname+"',valueField:'"+xname+"',";
   					if (xvisible=='false') str=str+"hidden:true,";
   					if (xemptytext!='') str=str+" emptyText:'"+xemptytext+"',";
   					if (xvalue!='') str=str+"value:'"+xvalue+"',";
				    str=str+"listeners:{ specialkey: function(field, e){  myKeyEvent(field,e,myFields,pageCount,mytab); }";
   					if (xderiveddim.length>0 || xaliasdim.length>0) {
						str=str+",select: function(combo, record, index) {";
						for (k=0;k<xderiveddim.length;k++) {
							str=str+"	var xtype=Ext.getCmp('"+xderiveddim[k]+"').getXType().toLowerCase();"; 
							str=str+"	if (xtype=='label') Ext.getCmp('"+xderiveddim[k]+"').setText(record[0].get('"+xderiveddim[k]+"'));";
							str=str+"	else Ext.getCmp('"+xderiveddim[k]+"').setValue(record[0].get('"+xderiveddim[k]+"'));";
						}
						for (k=0;k<xaliasdim.length;k++) {
							str=str+"	var xtype=Ext.getCmp('"+xaliasdim[k]+"').getXType().toLowerCase();"; 
							str=str+"	if (xtype=='label') Ext.getCmp('"+xaliasdim[k]+"').setText(Ext.getCmp('"+xname+"').getValue());"; 
							str=str+"	else Ext.getCmp('"+xaliasdim[k]+"').setValue(Ext.getCmp('"+xname+"').getValue());";
						}
						str=str+"}";
					}
   					str=str+"}};";
	   				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
	   				else str=str+"myForm"+xpage+".add(tmp);";
					pcobjects[n].xcommand=str;  //生成控件   						
	        	}else if (xtype=='checkbox'){ //combobox结束
	        		str="var tmp={xtype:'checkbox',boxLabel:'"+xlabel+"',id:'"+xname+"',name:'"+xname+"',inputValue:'"+xvalue+"',"; 
					if (xreadonly=='true') str=str+"readOnly:true,";
					str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight+",width:"+(xwidth*colWidth+xlabelwidth)+",height:"+xheight*rowHeight+",";
					if (xlabel=='') str=str+"hideLabel:true,";
					if (xvisible=='false') str=str+"hidden:true,";					
					if (xvalue=='0') str=str+",checked:false,";
					else str=str+",checked:true";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
					str=str+"};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
	     			else str=str+"myForm"+xpage+".add(tmp);";
					pcobjects[n].xcommand=str;  //生成控件
	        	}else if (xtype=='radio'){
	        		str="var tmp={xtype:'radiogroup',fieldLabel:'"+xlabel+"',id:'"+xname+"',name:'"+xname+"',";
					if (xreadonly=='true') str=str+"readOnly:true,";
					if (xvisible=='false') str=str+"hidden:true,";	
					if (xlabel=='') str=str+"hideLabel:true,";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
					str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight+",width:"+(xwidth*colWidth+xlabelwidth)+",";
					str=str+"items: [";
					for (k=0;k<xitemdim.length;k++){
						if(k==0) str=str+"{boxLabel:'"+xitemdim[k]+"',name:'x"+xname+"',inputValue:"+(k+1)+",checked:true}";
						else str=str+",{boxLabel:'"+xitemdim[k]+"',name:'x"+xname+"',inputValue:"+(k+1)+"}";
					}
					str=str+"]};";	
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
					pcobjects[n].xcommand=str;  //生成控件
				}else if (xtype=='textfield' || xtype=='keyfield' || xtype=='number' || xtype=='spin' || xtype=='password' || xtype=='email' || xtype=='url' || xtype=='alpha' || xtype=='alphanum') {
				//}else if (xtype in ['textfield','keyfield','number','spin','password','email','url','alpha','alphanum']) {
				    if (xtype=='keyfield'&&xname!='')  { 
    	   				pckeyfield=xname; 
       					pckeyspec=xlabel;
       				}
					str="var tmp={xtype:'textfield',fieldLabel:'"+xlabel+"',id:'"+xname+"',name:'"+xname+"',";
					if (xtype=='password') str=str+"inputType:'password',";
					if (xtype=='email'|| xtype=='alpha'|| xtype=='alphanum'|| xtype=='url') str=str+"vtype:'"+xtype+"',";
					if (xreadonly=='true') str=str+"readOnly:true,";
					if (xlabel=='') str=str+"hideLabel:true,";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
					str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight+",width:"+(xwidth*colWidth+xlabelwidth)+",";
   					if (xvisible=='false') str=str+"hidden:true,";
   					if (xmaxlength>0) str=str+"maxLength:"+xmaxlength+",enforceMaxLength:true,";
  					if (xemptytext!='') str=str+" emptyText:'"+xemptytext+"',";
   					if (xvalue!='') str=str+"value:'"+xvalue+"',";
   					if (xtype=='number' || xtype=='spin') {
   						if (xdecimal!=0) str=str+"decimalPrecision:"+xdecimal+",";
   						if (xmaxvalue!='' && !isNaN(xmaxvalue)) str=str+"maxValue:"+xmaxvalue+",";
   						if (xminvalue!='' && !isNaN(xminvalue)) str=str+"minValue:"+xminvalue+",";
   						if (xtype!='spin') { 
   							spinDownEnabled=false;
   							spinUPEnabled=false;
   						}
   					}
					str=str+" listeners:{specialkey: function(field, e){  myKeyEvent(field,e,myFields,pageCount,mytab); }";
     				if (xaliasdim.length>0) {
     					str=str+",change:function(view,newV,oldV){";
						for (k=0;k<xaliasdim.length;k++) {
							str=str+"	var xtype=Ext.getCmp('"+xaliasdim[k]+"').getXType().toLowerCase();"; 
							str=str+"	if (xtype=='label') Ext.getCmp('"+xaliasdim[k]+"').setText(newV);"; 
							str=str+"	else Ext.getCmp('"+xaliasdim[k]+"').setValue(newV);";
						}
     					str=str+"}";
    				}	        	
					str=str+"}};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
					pcobjects[n].xcommand=str;  //生成控件
				}else if (xtype=='label') {
					str="var tmp={xtype:'label',id:'"+xname+"',name:'"+xname+"',";
   					if (xvisible=='false') str=str+"hidden:true,";
   					if (xvalue!='') str=str+"text:'"+xvalue+"',";
   					else str=str+"text:'"+xlabel+"',"
					str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight;
					if (xwidth>0) str=str+",width:"+xwidth*colWidth;
					if (xlabelwidth>0) str=str+",labelWidth:"+xlabelwidth;
					str=str+"};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
    				else str=str+"myForm"+xpage+".add(tmp);";
					pcobjects[n].xcommand=str;  //生成控件
				}else if (xtype=='labeltext') {
					str="var tmp={xtype:'label',text:'"+xlabel+"',id:'x"+xname+"',name:'x"+xname+"',";
					str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight;
					if (xlabelwidth>0) str=str+",labelWidth:"+xlabelwidth;
					str=str+"};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
    				else str=str+"myForm"+xpage+".add(tmp);";
    				//生成可修改的label控件
					str=str+"tmp={xtype:'label',text:'',id:'"+xname+"',name:'"+xname+"',";
   					if (xvisible=='false') str=str+"hidden:true,";
   					if (xvalue!='') str=str+"text:'"+xvalue+"',";
   					else str=str+"text:'"+xlabel+"',"
					str=str+"x:"+(xleft*colWidth+xlabelwidth)+",y:"+xtop*rowHeight;
					str=str+",labelWidth:0";
					str=str+"};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
    				else str=str+"myForm"+xpage+".add(tmp);";
					pcobjects[n].xcommand=str;  //生成控件
				}else if (xtype=='textarea' || xtype=='memo') {
					str="var tmp={xtype:'textarea',fieldLabel:'"+xlabel+"',id:'"+xname+"',name:'"+xname+"',";
					if (xreadonly=='true') str=str+"readOnly:true,";
   					if (xvisible=='false') str=str+"hidden:true,";
   					if (xmaxlength>0) str=str+"maxLength:"+xmaxlength+",enforceMaxLength:true,";
   					if (xemptytext!='') str=str+" emptyText:'"+xemptytext+"',";
   					if (xvalue!='') str=str+"value:'"+xvalue+"',";
					if (xlabel=='') str=str+"hideLabel:true,";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
					str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight+",width:"+(xwidth*colWidth+xlabelwidth)+",height:"+xheight*rowHeight+",";
				    str=str+"listeners:{ specialkey: function(field, e){  myKeyEvent(field,e,myFields,pageCount,mytab); } }";
					str=str+"};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
					pcobjects[n].xcommand=str;  //生成控件
				}else if (xtype=='date' || xtype=='datefield') {
					str="var tmp={xtype:'datefield',fieldLabel:'"+xlabel+"',id:'"+xname+"',name:'"+xname+"',";
					if (xreadonly=='true') str=str+"readOnly:true,";
					if (xlabel=='') str=str+"hideLabel:true,";
   					if (xvisible=='false') str=str+"hidden:true,";
   					if (xemptytext!='') str=str+" emptyText:'"+xemptytext+"',";
   					if (xvalue!='') str=str+"value:'"+xvalue+"',";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
					str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight+",width:"+(xwidth*colWidth+xlabelwidth+16)+",";
					if (xformat=='') str=str+"format:'Y-n-j',";
					else str=str+"format:'"+xformat+"',";
					str=str+"listeners:{specialkey: function(field, e){  myKeyEvent(field,e,myFields,pageCount,mytab); }";
     				if (xaliasdim.length>0) {
     					str=str+",change:function(view,newV,oldV){";
						for (k=0;k<xaliasdim.length;k++) {
							str=str+"	var xtype=Ext.getCmp('"+xaliasdim[k]+"').getXType().toLowerCase();"; 
							str=str+"	if (xtype=='label') Ext.getCmp('"+xaliasdim[k]+"').setText(newV);"; 
							str=str+"	else Ext.getCmp('"+xaliasdim[k]+"').setValue(newV);";
						}
     					str=str+"}";
    				}	        	
					str=str+"}};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
					pcobjects[n].xcommand=str;  //生成控件
				}else if (xtype=='fileupload' || xtype=='imageupload') {
				    pcfileuploadpath=pfileuploadpath+xfilepath+"\\";
					if (xpanel>0) var formno=panelpage[xpanel];
					else var formno=xpage;
					str="var tmp={xtype:'textfield',fieldLabel:'"+xlabel+"',id:'filesourcename',name:'filesourcename',";
					str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight+",width:"+(xwidth*colWidth+xlabelwidth)+",";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
					str=str+"readOnly:true};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
     				//2
					str=str+" tmp={xtype:'textfield',fieldLabel:'文件大小：',id:'filesizedesc',name:'filesizedesc',";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
					str=str+"x:"+xleft*colWidth+",y:"+(xtop*rowHeight+rowHeight)+",width:240,";
					str=str+"readOnly:true};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
     				//3
					str=str+"tmp={xtype:'textfield',hidden:true,id:'fileosname',name:'fileosname'};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
     				//4
					str=str+"tmp={xtype:'numberfield',hidden:true,id:'filesize',name:'filesize'};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
     				//5
					str=str+"tmp={xtype:'textfield',inputType:'file',fieldLabel: '选择文件：',id:'filename',name:'filename',";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
		    		str=str+"x:"+xleft*colWidth+",y:"+(xtop*rowHeight+rowHeight*2)+",width:"+(xwidth*colWidth+xlabelwidth)+",";
		    		str=str+"buttonText:'浏览'};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
     				//6
					str=str+"tmp={xtype:'textfield',fieldLabel: '文件路径：',id:'filepath',name:'filepath',";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
		    		str=str+"x:"+xleft*colWidth+",y:"+(xtop*rowHeight+rowHeight*3)+",width:"+(xwidth*colWidth+xlabelwidth)+",";
					str=str+"readOnly:true};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
     				//7
					str=str+"tmp={xtype: 'button',text:'上传',id: 'cmd"+xname+"',name:'cmd"+xname+"',";
					if (xlabelwidth>0) str=str+"x:"+(xleft*colWidth+xlabelwidth-70+8)+",";
					else str=str+"x:"+xleft*colWidth+",";
		    		str=str+"y:"+(xtop*rowHeight+rowHeight*4)+",width:70,height:24";
					str=str+",handler:function(){";
					str=str+"	var xfilename=Ext.getCmp('filename').getValue();";
					str=str+"	var xid=pfileuploadpath+'"+xfilepath+"//"+pcgridtablename+"_'+Ext.getCmp(pcgridkeyfield).getValue();";
					str=str+"	var xfilesourcename=xfilename.substring(xfilename.lastIndexOf('\\\\')+1,xfilename.length);";
					str=str+"	var xfileosname=xid+xfilesourcename.substring(xfilesourcename.lastIndexOf('.'),xfilesourcename.length);";
					str=str+"	myForm"+formno+".submit({";  //只有自己所在表单才能上传
                    str=str+"   	method:'post',";
					str=str+"		url: 'fn_upLoadFile.jsp?filename='+xfilename+'&id='+xid,";
					str=str+"		waitTitle : '系统提示',";
					str=str+"		waitMsg:'文件正在上传...',";
					str=str+"		success: function(form,action){";
					str=str+"	  	var xfilesize=action.result.filesize;";
					str=str+"	  	var ximagewidth=action.result.imagewidth;";
					str=str+"	  	var ximageheight=action.result.imageheight;";
					str=str+"		Ext.MessageBox.show({";
        		    str=str+"        	title: '系统提示', ";  
					str=str+"			msg: '文件上传成功!',"; 
	                str=str+"        	buttons: Ext.Msg.OK,";
    	            str=str+"        	autoShow:true,";	                        
					str=str+"			icon: Ext.MessageBox.INFO";   
					str=str+"		});";
					str=str+"		Ext.getCmp('filepath').setValue(xfilename);";
					str=str+"		Ext.getCmp('filesourcename').setValue(xfilesourcename);"; 	
					str=str+"		Ext.getCmp('fileosname').setValue(xfileosname);";
					str=str+"		Ext.getCmp('filesize').setValue(xfilesize);";
					str=str+"		if (ximagewidth>0 && ximageheight>0) Ext.getCmp('filesizedesc').setValue(myFileSize(xfilesize)+';'+ximagewidth+';'+ximageheight);";
					str=str+"		else Ext.getCmp('filesizedesc').setValue(myFileSize(xfilesize));";
					str=str+"		fnShowPicture();"	
					str=str+"	},";
					str=str+"	failure : function(form, action) {";
					str=str+"		var status = action.result.status;";
					str=str+"		Ext.MessageBox.show({";   
       		        str=str+"    		title: '系统警告',";   
                	str=str+"	        msg: status+'<br>文件上传失败！',"; 
					str=str+"			buttons: Ext.Msg.OK,";
   	                str=str+"    		autoShow:true,";	                        
		            str=str+"            icon: Ext.MessageBox.WARNING";   
   			        str=str+"       });";
					str=str+"		Ext.getCmp('filepath').setValue('');";
					str=str+"		Ext.getCmp('filesourcename').setValue('');"; 	
					str=str+"		Ext.getCmp('fileosname').setValue('');";
					str=str+"		Ext.getCmp('filesize').setValue('0 KB');";
					str=str+"		Ext.getCmp('filesizedesc').setValue('');";
					str=str+"	}";
					str=str+"});";
					str=str+"}";
					str=str+"};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
     				if (xtype=='imageupload') {
	     				//8
						pcimageheight=xheight*rowHeight;
						pcimagewidth=xwidth*colWidth;
						var str1="tmp={xtype:'image',fieldLabel:'图片预览：',id:'sysimage1',name:'sysimage1',";
						if (xlabelwidth>0) str1=str1+"labelWidth:"+xlabelwidth+",";
		    			str1=str1+"x:"+xleft*colWidth+",y:"+(xtop*rowHeight+rowHeight*5+6)+",width:"+(xwidth*colWidth+xlabelwidth)+",height:"+(xheight*rowHeight);
						str1=str1+"};";
	    				if (xpanel>0) str1=str1+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
    	 				else str1=str1+"myForm"+xpage+".add(tmp);";
						str=str+str1;
     					//9
     					str1="tmp={xtype:'checkbox',boxLabel:'预览图片',id:'sysshowpicture',name:'sysshowpicture',";
		    			str1=str1+"x:"+(xleft*colWidth+120)+",y:"+(xtop*rowHeight+rowHeight*4)+",width:"+(xwidth*colWidth+xlabelwidth)+",";
     					str1=str1+"inputValue:'1',checked:true,"; 
						str1=str1+"listeners: {";
						str1=str1+"'change':function(r,checked){var	checkValue=r.getRawValue();fnShowPicture();";
						str1=str1+"} } };";
    					if (xpanel>0) str1=str1+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     					else str1=str1+"myForm"+xpage+".add(tmp);";
						str=str+str1;
					}	
					pcobjects[n].xcommand=str;  //生成控件
	        	}else if (xtype=='treefield') {
	        		if (xsql=='') xsql="select * from "+xtablename;
	        		str="var selectedcode"+xname+"='';";
	        		str=str+" var rootcode"+xname+"='';";
					str=str+" var treeStore_"+xname+"=Ext.create('Ext.data.TreeStore',{";
					str=str+" extend: 'Ext.data.Model',";
					str=str+"fields: [{name: 'cid',  type: 'string'},{name: 'text',  type: 'string'},{name: 'flag',  type: 'string'}";
					for(k=0;k<xfielddim.length;k++) {
	        			str=str+",{name:'"+xfielddim[k]+"',type:'string'}";
	        		}
		        	str=str+"]";	
		    		str=str+",proxy: { type: 'ajax' }";
			    	str=str+",listeners:{";
	        		str=str+"	load:function(store){"
					str=str+" 	if (rootcode"+xname+"=='') {";
			        str=str+" 	 	var root=store.getRootNode();";
					str=str+" 		var node=root.findChild('cid',selectedcode"+xname+",true);";
					str=str+" 		if(node!=null){"; 
					str=str+" 			var pNode=node.parentNode;";
					str=str+" 			for (; pNode!=root; pNode=pNode.parentNode) {";
					str=str+" 				pNode.expand();";
					str=str+" 			}";
					str=str+" 			tree_"+xname+".getSelectionModel().select(node);";
					str=str+" 		}";
					str=str+" 	}else{";
					str=str+" 		tree_"+xname+".getSelectionModel().select(0);";
					str=str+" 	} } }";
					str=str+" } );";
					//store	
	    			str=str+"var tree_"+xname+"=Ext.create('Ext.tree.Panel', {";
	        		str=str+"	store:treeStore_"+xname+",";
		    		str=str+"	x:0,y:0,width:"+(xwidth*colWidth+xlabelwidth-13)+",height:"+xheight*rowHeight+",";
	    		    str=str+"	animate: false,";
	    		    if (xlabel=='') str=str+"hideLabel:true,";
			        str=str+"	collapsible: false,";
	    		    str=str+"	border: false,";
	    		    str=str+"	rootVisible: false,";
			        str=str+"	multiSelect: false,";
	    		    str=str+"	listeners: {";
					str=str+"		itemmouseenter:function(view, record, item, index, e){";
					str=str+"			rootcode"+xname+"=record.raw.cid;";
					str=str+"			selectedcode"+xname+"='';";
					str=str+"		},";
					str=str+"	beforeload:function(store,options) {";
					str=str+"		var newparams={maxReturnNumber:maxReturnNumber,sqlString:'"+xsql+"',tableName:'"+xtablename+"',keyField:'"+xkeyfield+"',searchText:'',rootCode:rootcode"+xname+",selectedCode:selectedcode"+xname+"};";
					str=str+"		Ext.apply(store.proxy.extraParams,newparams);";
					str=str+"		store.proxy.url='fn_getTreeNode.jsp';";				
					str=str+"	},";
	        		str=str+"	itemdblclick: function(view,record,item,index,event) {";
	            	str=str+"		if(record.get('leaf')){";
	            	str=str+"		Ext.getCmp('"+xname+"').setValue(record.get('"+xname+"'));";
   					if (xderiveddim.length>0 || xaliasdim.length>0) {
						for (k=0;k<xderiveddim.length;k++) {
							str=str+"	var xtype=Ext.getCmp('"+xderiveddim[k]+"').getXType().toLowerCase();"; 
							str=str+"	if (xtype=='label') Ext.getCmp('"+xderiveddim[k]+"').setText(record.get('"+xderiveddim[k]+"'));";
							str=str+"	else Ext.getCmp('"+xderiveddim[k]+"').setValue(record.get('"+xderiveddim[k]+"'));";
						}
						for (k=0;k<xaliasdim.length;k++) {
							str=str+"	var xtype=Ext.getCmp('"+xaliasdim[k]+"').getXType().toLowerCase();"; 
							str=str+"	if (xtype=='label') Ext.getCmp('"+xaliasdim[k]+"').setText(Ext.getCmp('"+xname+"').getValue());"; 
							str=str+"	else Ext.getCmp('"+xaliasdim[k]+"').setValue(Ext.getCmp('"+xname+"').getValue());";
						}
					}
					str=str+"	selectedcode"+xname+"=record.get('"+xkeyfield+"');";	            		
	            	str=str+"	rootcode"+xname+"='';"; 
	            	str=str+"	win_"+xname+".hide();"
					str=str+"};";
	            	str=str+"} } });";
	            	//window
	            	str=str+"var win_"+xname+"=Ext.create('Ext.window.Window', {";
					str=str+"	title: '选择"+xlabel+"',";
		    		str=str+"	width:"+(xwidth*colWidth+xlabelwidth)+",height:"+(xheight*rowHeight+35)+",";
					str=str+"	closeAction: 'hide',";
					str=str+"	modal:true,";
					str=str+"	resizable:false,";
					str=str+"	layout: 'absolute',";
					str=str+"	items:[tree_"+xname+"],";
					str=str+"	listeners:{";
	    			str=str+"	show:function(){";
					//str=str+"		treeStore_"+xname+".load();"
	    			str=str+"	}}});";
	            	//生成2个控件
	            	str=str+"var tmp={xtype:'textfield',fieldLabel:'"+xlabel+"',id:'"+xname+"',name:'"+xname+"',";
	            	if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";	            	
   					if (xvisible=='false') str=str+"hidden:true,";
   					if (xmaxlength>0) str=str+"maxLength:"+xmaxlength+",enforceMaxLength:true,";
   					if (xemptytext!='') str=str+" emptyText:'"+xemptytext+"',";
   					if (xvalue!='') str=str+"value:'"+xvalue+"',";
		    		str=str+"x:"+xleft*colWidth+",y:"+xtop*rowHeight+",width:"+(xwidth*colWidth+xlabelwidth)+",";
					str=str+"readOnly:true";
					str=str+"};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
					//按钮
					str=str+"tmp={xtype:'button',id:'cmd"+xname+"',name:'cmd"+xname+"',text:'...',";
					if (xlabelwidth>0) str=str+"labelWidth:"+xlabelwidth+",";
	            	str=str+"x:"+(xleft*colWidth+xwidth*colWidth+xlabelwidth+10)+",y:"+xtop*rowHeight+",width:25,height:24,";
					str=str+"handler:function(){";
					str=str+"	selectedcode"+xname+"=Ext.getCmp('"+xkeyfield+"').getValue();";
					str=str+"	rootcode"+xname+"='';";						
					str=str+"	treeStore_"+xname+".load();";
					str=str+"	var xy=[];";
					str=str+"	xy=Ext.getCmp('"+xname+"').getPosition(false).toString().split(',');";
					if (xlabel!='') str=str+"	var x1=parseInt(xy[0])+"+(xlabelwidth+4)+";";
					else str=str+"	var x1=parseInt(xy[0])+0;";
					str=str+"	var y1=parseInt(xy[1])+Ext.getCmp('categoryname').getHeight()+2;";
					str=str+"	win_"+xname+".setPosition(x1,y1);";
					str=str+"	win_"+xname+".show();";
					str=str+"}};";
    				if (xpanel>0) str=str+"Ext.getCmp('myFieldSet"+xpanel+"').add(tmp);";
     				else str=str+"myForm"+xpage+".add(tmp);";
					pcobjects[n].xcommand=str;  //生成控件					
	        	}	
    	    	//alert(pcobjects[n].xname+','+pcobjects[n].xtype);
			}
		}  //type=1
	} //for i
  	if ((pcwintitle=='')&&(pctitle!='')) pcwintitle=pctitle;
  	if ((pctitle=='')&&(pcwintitle!='')) pctitle=pcwintitle;
	if (pckeyfield=='') {
		pckeyfield=pcobjects[1].xname;
    	pckeyspec=pcobjects[1].xlabel;
	}
	for (i=0;i<pcobjects.length;i++){
		var xname=pcobjects[i].xname;
		if (xname!=undefined && xname!='') {
			pcformfieldnames=pcformfieldnames+';'+xname;
			var	xvalue=pcobjects[i].xvalue;
			if (pcobjects[i].xaliasfields!='') {
				xaliasdim=pcobjects[i].xaliasfields.split(';');
				for (k=0;k<xaliasdim.length;k++) {
					//生成等式控件
					pcaliasfieldstr=pcaliasfieldstr+" if (Ext.getCmp('"+xaliasdim[k]+"')==null) {"
					pcaliasfieldstr=pcaliasfieldstr+" 	var tmp={xtype:'textfield',id:'"+xaliasdim[k]+"',name:'"+xaliasdim[k]+"',hidden:true};";
					pcaliasfieldstr=pcaliasfieldstr+"	myForm1.add(tmp); }";
					//生成replace控件,转换日期格式，处理label类型
					pcreplacestr=pcreplacestr+"	if (Ext.getCmp('"+xaliasdim[k]+"')!=null) {"; 
					pcreplacestr=pcreplacestr+"		var xtype=Ext.getCmp('"+xaliasdim[k]+"').getXType().toLowerCase();"; 
					pcreplacestr=pcreplacestr+"		var ptype=Ext.getCmp('"+pcobjects[i].xname+"').getXType().toLowerCase();"; 
					pcreplacestr=pcreplacestr+"		var xvalue=Ext.getCmp('"+pcobjects[i].xname+"').getValue();";
					pcreplacestr=pcreplacestr+"		if (ptype=='datefield') xvalue=Ext.util.Format.date(xvalue,'Y-m-d');";
					pcreplacestr=pcreplacestr+"		if (xtype=='label') Ext.getCmp('"+xaliasdim[k]+"').setText(xvalue);";
					pcreplacestr=pcreplacestr+"		else Ext.getCmp('"+xaliasdim[k]+"').setValue(xvalue);";
					pcreplacestr=pcreplacestr+"	}";
				}
			}else if(xvalue!=undefined && xvalue!='' && xvalue.substring(0,4)=='#sys'){
				if (xvalue=='#sysdate') pcreplacestr=pcreplacestr+" Ext.getCmp('"+xname+"').setValue(myGetDate('-'));";
				else pcreplacestr=pcreplacestr+" Ext.getCmp('"+xname+"').setValue("+xvalue.substring(1)+");"; 		
			}
		}
	}
//	alert(pcaliasfieldstr);	
	//处理过滤菜单集
	pccheckmemusetstr=''; 
    var tmpStr=pcfilterfields.split(';');
    var tmpStr1='var menuCheck=[';
    for (var k=0;k<tmpStr.length;k++) {
    	var tmpStr2=tmpStr[k].split('/');
    	if (k>0) tmpStr1=tmpStr1+',';
		tmpStr1=tmpStr1+"'1:"+tmpStr2[0]+"'";
		pccheckmemusetstr=pccheckmemusetstr+"var tmpItem={xtype:'menucheckitem',text:'"+tmpStr2[1]+"',id:'menu_"+tmpStr2[0]+"',checked:true,";
		pccheckmemusetstr=pccheckmemusetstr+"	listeners:{	checkchange:function(item,checked){";
		pccheckmemusetstr=pccheckmemusetstr+"		if(checked){ menuCheck["+k+"]='1:"+tmpStr2[0]+"';";
	  	pccheckmemusetstr=pccheckmemusetstr+"		}else{ menuCheck["+k+"]='0:"+tmpStr2[0]+"';";
		pccheckmemusetstr=pccheckmemusetstr+"	} }	} }";
		pccheckmemusetstr=pccheckmemusetstr+";";
		pccheckmemusetstr=pccheckmemusetstr+"checkMenuSet.push(tmpItem);";
    }
	tmpStr1=tmpStr1+']';
    pccheckmemusetstr=pccheckmemusetstr+tmpStr1;  //直接生成菜单checkMenuSet和menuCheck	
    
    //生成form的fieldset
    if (pcformfieldnames!='') pcformfieldnames=pcformfieldnames.substring(1);
	var tmpStr=pcformfieldnames.split(';');
	pcformfieldsetstr='';
	for (k=0;k<tmpStr.length;k++) {
		pcformfieldsetstr=pcformfieldsetstr+",{name:'"+tmpStr[k]+"',type:'string'}";
	}
};
  
 