<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
 String action = request.getParameter("action");
 if("signout".equals(action)){
     session.removeAttribute("user");
     session.removeAttribute("action");
     
     response.setCharacterEncoding("UTF-8");
     response.getWriter().write("success"); 
 }
 %>
