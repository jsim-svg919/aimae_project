package com.aimae.model;

import java.util.Random;

public class AuthCodeGenerator {

	private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

	public static String RandomCode(int length) {

		Random random = new Random();
		StringBuilder sb = new StringBuilder(length);

		for (int i = 0; i < length; i++) {
			int randomIndex = random.nextInt(CHARACTERS.length());
			sb.append(CHARACTERS.charAt(randomIndex));
		}

		return sb.toString();

	}

}
