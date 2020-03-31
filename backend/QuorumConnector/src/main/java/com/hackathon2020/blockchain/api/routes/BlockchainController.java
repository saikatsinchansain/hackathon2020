/**
 * 
 */
package com.hackathon2020.blockchain.api.routes;

import java.util.Map;

import org.apache.camel.CamelContext;
import org.apache.camel.Endpoint;
import org.apache.camel.Exchange;
import org.apache.camel.ExchangePattern;
import org.apache.camel.Message;
import org.apache.camel.Produce;
import org.apache.camel.ProducerTemplate;
import org.apache.camel.spi.UnitOfWork;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author Saikat
 *
 */
@RestController
public class BlockchainController {

	@Produce(uri = "direct:start")
    private ProducerTemplate template;
	
	@GetMapping("/greetings")
	public String greeetings()
	{
		
		return "Hello";
	}
}
