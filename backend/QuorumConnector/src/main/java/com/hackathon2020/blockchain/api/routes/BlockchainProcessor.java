package com.hackathon2020.blockchain.api.routes;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import org.apache.camel.Exchange;
import org.apache.camel.component.web3j.Web3jConstants;
import org.web3j.abi.FunctionEncoder;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Uint;
import org.web3j.abi.datatypes.Utf8String;

import com.hackathon2020.blockchain.model.Courses;

public class BlockchainProcessor {
	
	public void get(Exchange exchange)
	{
		List<TypeReference<?>> outputParameters = new ArrayList<>(2);
		outputParameters.add((TypeReference<?>) new TypeReference<Utf8String>() {});
		outputParameters.add((TypeReference<?>) new TypeReference<Uint>() {});
		
		Function function = new Function(Courses.FUNC_GETINSTRUCTOR,Collections.<Type> emptyList(),
				outputParameters);
		exchange.getIn().setHeader(Web3jConstants.DATA, FunctionEncoder.encode(function));
	}
	
	public void update(Exchange exchange)
	{
		
		List<Type> inputParameters = new ArrayList<>(2);
		inputParameters.add(new Utf8String("Hello"));
		inputParameters.add(new Uint(BigInteger.valueOf(10L)));
		Function function = new Function(Courses.FUNC_SETINSTRUCTOR,inputParameters,
				Collections.<TypeReference<?>> emptyList());
		exchange.getIn().setHeader(Web3jConstants.DATA, FunctionEncoder.encode(function));
	}
	
	public void deploy(Exchange exchange)
	{
		//Arrays.<Type> asList(new Uint(BigInteger.valueOf(100L)))
		String function = FunctionEncoder.encodeConstructor(Collections.<Type> emptyList());
		exchange.getIn().setHeader(Web3jConstants.DATA, "0x" + Courses.BINARY + function);
	}


}
