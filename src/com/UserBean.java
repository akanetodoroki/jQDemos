package com;

import java.sql.Date;

public class UserBean {
	private String userid;
	private String useraccount;
	private String username;
	private String usertype;
	private String userpassword;
	private String userright;
	private String userlogindate;
	private String action;
	private String flag;
	private String notes;
	
	public UserBean(){
		
	}
	public UserBean(
		String userid, 
		String useraccount, 
		String username, 
		String userpassword, 
		String usertype, 
		String userright, 
		String userlogindate,
		String action,
		String flag,
		String notes){
		this.userid = userid;
		this.useraccount = useraccount;
		this.username = username;
		this.userpassword = userpassword;
		this.usertype = usertype;
		this.userright = userright;
		this.userlogindate = userlogindate;
		this.action = action;
		this.flag = flag;
		this.notes = notes;
	}
	public String getUseraccount() {
		return useraccount;
	}
	public void setUseraccount(String useraccount) {
		this.useraccount = useraccount;
	}
	
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getUsertype() {
		return usertype;
	}
	public void setUsertype(String usertype) {
		this.usertype = usertype;
	}
	
	public String getUserpassword() {
		return userpassword;
	}
	public void setUserpassword(String userpassword) {
		this.userpassword = userpassword;
	}
	
	public String getLogindate() {
		return userlogindate;
	}
	public void setLogindate(String logindate) {
		this.userlogindate = userlogindate;
	}

	public String getNotes() {
		return notes;
	}
	public void setNotes(String notes) {
		this.notes = notes;
	}
	
	public String getUserright() {
		return userright;
	}
	public void setUserright(String userright) {
		this.userright = userright;
	}
	
	public String getAction() {
		return action;
	}
	public void setAction(String action) {
		this.action = action;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
}
