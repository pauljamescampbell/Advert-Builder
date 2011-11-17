package com.guardian.advertbuilder.errors {
	/**
	 * @author plcampbell
	 */
	public class DocumentError extends Error {
		
		public function DocumentError(message : * = "", id : * = 0) {
			super(message, id);
		}
	}
}
