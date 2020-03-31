package com.hackathon2020.blockchain.api.routes;

import org.apache.camel.Body;

public class MessageProcessor {
	public String toString(@Body String args)
	{
		return args;
	}
	
	public int parseInt(@Body String args)
	{
		return Integer.parseInt(args.replace("0x",""),16);
	}
	
	
}
