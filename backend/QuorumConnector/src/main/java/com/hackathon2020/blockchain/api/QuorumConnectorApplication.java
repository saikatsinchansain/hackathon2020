package com.hackathon2020.blockchain.api;

import org.apache.camel.CamelContext;
import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.servlet.CamelHttpTransportServlet;
import org.apache.camel.impl.DefaultCamelContext;
import org.apache.camel.model.rest.RestBindingMode;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.http.MediaType;

import com.hackathon2020.blockchain.api.routes.BlockchainService;

@SpringBootApplication
public class QuorumConnectorApplication extends RouteBuilder {

	public static void main(String[] args) {
		SpringApplication.run(QuorumConnectorApplication.class, args);
	}

	Processor myProcessor = new Processor() {
		public void process(Exchange exchange) {
			log.debug("Called with exchange: " + exchange);
		}
	};
	
	@Value("${camel.api.path}")
	String contextPath;
	
	@Bean
	ServletRegistrationBean servletRegistrationBean() {
	    ServletRegistrationBean servlet = new ServletRegistrationBean
	      (new CamelHttpTransportServlet(), contextPath+"/*");
	    servlet.setName("CamelServlet");
	    return servlet;
	}

	@Override
	public void configure() throws Exception {
		//CamelContext context = new DefaultCamelContext();
		restConfiguration().component("servlet").port(8080).enableCORS(true).bindingMode(RestBindingMode.json);
		
		
		from("direct:start").process(myProcessor);
		
		//from("file:C:/Users/Saikat/a?noop=true").to("file:C:/Users/Saikat/b");
		
		rest().get("/greet").to("direct:accounts");
		
		
	}

}
