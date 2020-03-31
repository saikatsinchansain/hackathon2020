package com.hackathon2020.blockchain.api.routes;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.web3j.Web3jConstants;
import org.springframework.stereotype.Component;
import org.web3j.protocol.core.DefaultBlockParameter;
import org.web3j.protocol.core.DefaultBlockParameterName;

@Component
public class BlockchainRoutes extends RouteBuilder {

	private static String ENDPOINT = "web3j://http://52.195.0.50:22000";
	private static String PUBLICKEY = "0x98347583497";
	private static long PRICE = 0;
	private static long LIMIT = 0;
	private static String DATA = "BYTE CODE DATA";
	@Override
	public void configure() throws Exception {

		from("direct:accounts").to("web3j://http://52.195.0.50:22000?operation=ETH_ACCOUNTS&atBlock=0");

		from("direct:getData").to("direct:accounts")
		.setHeader(Web3jConstants.FROM_ADDRESS, body())
		.setHeader(Web3jConstants.OPERATION, constant(Web3jConstants.ETH_CALL))
		.setHeader(Web3jConstants.TO_ADDRESS, header("smart_contract_address"))
		.setHeader(Web3jConstants.AT_BLOCK,constant(DefaultBlockParameterName.LATEST))
		.bean(BlockchainProcessor.class,"get")
		.to(ENDPOINT+"quorumAPI=true")
		.bean(MessageProcessor.class,"parse");
		
		from("direct:updateSmartContract").to("direct:accounts")
		.setHeader(Web3jConstants.FROM_ADDRESS, body())
		.setHeader(Web3jConstants.OPERATION, constant(Web3jConstants.QUORUM_ETH_SEND_TRANSACTION))
		.setHeader(Web3jConstants.GAS_PRICE,constant(PRICE))
		.setHeader(Web3jConstants.GAS_LIMIT,constant(LIMIT))
		.setHeader(Web3jConstants.AT_BLOCK,constant(DefaultBlockParameterName.LATEST))
		.setHeader(Web3jConstants.TO_ADDRESS, header("smart_contract_address"))
		.bean(BlockchainProcessor.class,"update")
		.to(ENDPOINT+"quorumAPI=true");
		
		from("direct:PublicContractDeployer").to("direct:accounts")
		.setHeader(Web3jConstants.FROM_ADDRESS, body())
		.setHeader(Web3jConstants.OPERATION, constant(Web3jConstants.QUORUM_ETH_SEND_TRANSACTION))
		.setHeader(Web3jConstants.GAS_PRICE,constant(PRICE))
		.setHeader(Web3jConstants.GAS_LIMIT,constant(LIMIT))
		.setHeader(Web3jConstants.AT_BLOCK,constant(DefaultBlockParameterName.LATEST))
		.setHeader(Web3jConstants.DATA,constant(DATA))
		.to(ENDPOINT+"quorumAPI=true");
		
		from("direct:PrivateContractDeployer").to("direct:accounts")
			.setHeader(Web3jConstants.FROM_ADDRESS, body())
			.setHeader(Web3jConstants.OPERATION, constant(Web3jConstants.QUORUM_ETH_SEND_TRANSACTION))
			.setHeader(Web3jConstants.GAS_PRICE,constant(PRICE))
			.setHeader(Web3jConstants.GAS_LIMIT,constant(LIMIT))
			.setHeader(Web3jConstants.PRIVATE_FOR,constant(PUBLICKEY))
			.setHeader(Web3jConstants.AT_BLOCK,constant(DefaultBlockParameterName.LATEST))
			.setHeader(Web3jConstants.DATA,constant(DATA))
			.to(ENDPOINT+"quorumAPI=true");
	}

}
