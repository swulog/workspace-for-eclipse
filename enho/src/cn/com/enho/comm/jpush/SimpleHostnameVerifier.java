package cn.com.enho.comm.jpush;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;

public class SimpleHostnameVerifier implements HostnameVerifier {

	@Override
	public boolean verify(String hostname, SSLSession session) {
		return true;
	}

}
